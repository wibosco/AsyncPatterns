//
//  ViewController.swift
//  AsyncPatterns
//
//  Created by Wojciech Chojnacki on 08/11/2016.
//  Copyright © 2016 chojnac.com All rights reserved.
//

import UIKit
import BrightFutures
import Result

class ViewController: UITableViewController {
    
    var process:[(String, ProcessState)] = [
        ("pasterise", .waiting),
        ("inoculate", .waiting),
        ("texture", .waiting),
        ("salt", .waiting),
        ("age", .waiting)
    ]
    
    var invalidationToken: InvalidationToken?
    
    var processActive:Bool = false {
        didSet {
            let item: UIBarButtonItem
            if processActive {
                item = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(stopAction(_:)))
            } else {
                item = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(startAction(_:)))
                invalidationToken?.invalidate()
            }
            self.navigationItem.rightBarButtonItems = [item]
        }
    }
    
    
    
    weak var barButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ProcessTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell1")
        processActive = false
    }

    
    @IBAction func startAction(_ sender: UIBarButtonItem) {
        startProcess()
    }
    
    @IBAction func stopAction(_ sender: UIBarButtonItem) {
        stopProcess()
    }
    

    func startProcess() {
        guard !processActive else {
            return
        }
        process = process.map {
            ($0.0, .waiting)
        }
        processActive = true
        tableView.reloadData()
        
//        runProcessWithCallbacks1()
//        runProcessWithCallbacks2()
        runProcessWithFutures()
    }
    
    
    
    func stopProcess() {
        guard processActive else {
            return
        }
        processActive = false
        process = process.map {
            if case .waiting = $0.1  {
                return ($0.0, .complete(success: false))
            }
            return $0
        }
        tableView.reloadData()
    }
    
    func processSuccess() {
        guard processActive else {
            return
        }
        processActive = false
    }
    
    func updateStep(idx: Int, state: ProcessState) {
        process[idx] = (process[idx].0, state)
        let indexPath = IndexPath(row: idx, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}


extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return process.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1") as? ProcessTableViewCell
            else {
            return UITableViewCell()
        }
        
        let item = process[indexPath.row]
        
        cell.configure(title: item.0, state: item.1)
        
        return cell
    }
}


/// Process implementations
///

extension ViewController {
    
    //MARK: - runProcessWithCallbacks1
    func runProcessWithCallbacks1() {
        let factory = CheeseFactory()
        
        var step = 0
        updateStep(idx: step, state: .inprogress)
        
        func sideEffect() -> Void {
            self.updateStep(idx: step, state: .complete(success: true))
            step += 1
            self.updateStep(idx: step, state: .inprogress)
        }
        
        factory.pasterise(milk: Milk(pasterised: false)) { (milk, error) in
            guard let milk = milk, error == nil else {
                self.stopProcess()
                return
            }
            
            sideEffect()
            
            factory.inoculate(milk: milk, bacteria: Bacteria()) { (product, error) in
                guard let product = product, error == nil else {
                    self.stopProcess()
                    return
                }
                
                guard self.processActive else {
                    self.updateStep(idx: step, state: .cancelled)
                    return
                }
                
                sideEffect()
                
                factory.texture(curd: product.0) { (product, error) in
                    guard let product = product, error == nil else {
                        self.stopProcess()
                        return
                    }
                    
                    guard self.processActive else {
                        self.updateStep(idx: step, state: .cancelled)
                        return
                    }
                    
                    sideEffect()
                    
                    factory.salt(curd: product.0) { (curdBlock, error) in
                        guard let curdBlock = curdBlock, error == nil else {
                            self.stopProcess()
                            return
                        }
                        
                        guard self.processActive else {
                            self.updateStep(idx: step, state: .cancelled)
                            return
                        }
                        
                        sideEffect()
                        
                        factory.age(curd: curdBlock) { (cheese, error) in
                            guard let _ = cheese, error == nil else {
                                self.stopProcess()
                                return
                            }
                            
                            guard self.processActive else {
                                self.updateStep(idx: step, state: .cancelled)
                                return
                            }
                            
                            self.updateStep(idx: step, state: .complete(success: true))
                            self.processSuccess()
                        }
                        
                    }
                }
            }
        }
    }
    
    //MARK: - runProcessWithCallbacks2
    func runProcessWithCallbacks2() {
        let factory = CheeseFactory()
        
        var step = 0
        updateStep(idx: step, state: .inprogress)
        
        func sideEffect() -> Void {
            self.updateStep(idx: step, state: .complete(success: true))
            guard step<process.count-1 else {
                return
            }
            
            step += 1
            self.updateStep(idx: step, state: .inprogress)
        }
        
        func handler<U>(_ f: @escaping ((U) -> Void) ) -> ((U?, Error?) -> Void)  {
            return { (product:U?, error:Error?) in
                guard let product = product, error == nil else {
                    self.stopProcess()
                    return
                }
                
                guard self.processActive else {
                    self.updateStep(idx: step, state: .cancelled)
                    return
                }
                
                sideEffect()
                
                f(product)
            }
        }
        
        
        
        factory.pasterise(milk: Milk(pasterised: false),complete: handler({ milk in
            factory.inoculate(milk: milk, bacteria: Bacteria(), complete: handler({ product in
                factory.texture(curd: product.0, complete: handler({ product in
                    factory.salt(curd: product.0, complete: handler({ curdBlock in
                        factory.age(curd: curdBlock, complete: handler({ cheese in
                            self.updateStep(idx: step, state: .complete(success: true))
                            self.processSuccess()
                        }))
                    }))
                }))
            }))
        }))
    }
    
    //MARK: - runProcessWithFutures
    func runProcessWithFutures() {
        let factory = WithFuturesCheeseFactory()
        
        var step = 0
        updateStep(idx: step, state: .inprogress)
        
        invalidationToken = InvalidationToken()
        
        guard let invalidationToken = invalidationToken else {
            return
        }
        
        invalidationToken.future.onFailure { _ in
            self.updateStep(idx: step, state: .cancelled)
        }
        
        func sideEffect<U>(_ result: Result<U, SpoiledProductError>) -> Void {
            self.updateStep(idx: step, state: .complete(success: true))
            step += 1
            self.updateStep(idx: step, state: .inprogress)
        }
        
        
        let process = factory.pasterise(milk: Milk(pasterised: false))
            .andThen(context:invalidationToken.validContext, callback: sideEffect)
            .flatMap(invalidationToken.validContext) { (milk) -> Future<(Curd, Whey), SpoiledProductError> in
                return factory.inoculate(milk: milk, bacteria: Bacteria())
            }
            .andThen(context:invalidationToken.validContext, callback: sideEffect)
            .flatMap(invalidationToken.validContext) { (product) -> Future<(CurdBlock, Whey), SpoiledProductError> in
                return factory.texture(curd: product.0)
            }
            .andThen(context:invalidationToken.validContext, callback: sideEffect)
            .flatMap(invalidationToken.validContext) { (product) -> Future<CurdBlock, SpoiledProductError> in
                return factory.salt(curd: product.0)
            }
            .andThen(context:invalidationToken.validContext, callback: sideEffect)
            .flatMap(invalidationToken.validContext) { (curdBlock) -> Future<CheeseBlock, SpoiledProductError> in
                return factory.age(curd: curdBlock)
        }
        
        process.onSuccess(invalidationToken.validContext) { (cheese) in
            self.updateStep(idx: step, state: .complete(success: true))
            self.processSuccess()
        }
        
        process.onFailure { (error) in
            self.stopProcess()
        }
    }
}

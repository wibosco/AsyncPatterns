//
//  CheeseOperation.swift
//  AsyncPatterns
//
//  Created by William Boles on 15/12/2016.
//  Copyright © 2016 Memrise. All rights reserved.
//

import UIKit

enum CheeseProductionStep: Int {
    case pasterise = 0
    case inoculate
    case texture
    case salt
    case curdAge
    case cheeseAge
}

class CheeseOperation: Operation {

    typealias ProgressClosure = (_ step: CheeseProductionStep, _ error: SpoiledProductError?) -> Void
    typealias CompletionClosure = (_ cheese: CheeseBlock) -> Void
    
    let progress: ProgressClosure
    let completion: CompletionClosure
    
    // MARK: Init
    
    init(progress: @escaping ProgressClosure, completion: @escaping CompletionClosure) {
        self.progress = progress
        self.completion = completion
        super.init()
    }
    
    // MARK: Main
    
    override func main() {
        super.main()
        
        guard let pasterisedMilk = pasterise(milk: Milk(pasterised: false))  else {
            return
        }
        
//        guard let inoculatedCurd = inoculate(milk: pasterisedMilk, bacteria: Bacteria()) else {
//            return
//        }
//        
//        let texturedCurdBlock = texture(curd: inoculatedCurd)
//        
//        guard let saltedCurdBlock = salt(curd: texturedCurdBlock) else {
//            return
//        }
//        
//        guard let agedCheese = ageCurd(curd: saltedCurdBlock) else {
//            return
//        }
        
//        completion(ageCheese(cheese: agedCheese))
    }
    
    // MARK: Production
    
    func pasterise(milk: Milk) -> Milk? {
        sleep(2)
        guard !milk.pasterised else {
            progress(.pasterise, SpoiledProductError())
            return nil
        }
        
        progress(.pasterise, nil)
        return Milk(pasterised: true)
    }
    
    func inoculate(milk: Milk, bacteria: Bacteria) -> Curd? {
        guard milk.pasterised else {
            progress(.inoculate, SpoiledProductError())
            return nil
        }
        
        progress(.inoculate, nil)
        
        return Curd()
    }
    
    func texture(curd: Curd) -> CurdBlock {
        progress(.texture, nil)
        
        return CurdBlock(salted: false)
    }
    
    func salt(curd: CurdBlock) -> CurdBlock? {
        guard !curd.salted else {
            progress(.salt, SpoiledProductError())
            return nil
        }
        
        progress(.salt, nil)
        
        return CurdBlock(salted: true)
    }
    
    func ageCurd(curd: CurdBlock) -> CheeseBlock? {
        guard curd.salted else {
            progress(.curdAge, SpoiledProductError())
            return nil
        }
        
        progress(.curdAge, nil)
        
        return CheeseBlock(age: 2)
    }
    
    func ageCheese(cheese: CheeseBlock) -> CheeseBlock {
        progress(.cheeseAge, nil)
        
        return CheeseBlock(age: cheese.age + 2)
    }
}

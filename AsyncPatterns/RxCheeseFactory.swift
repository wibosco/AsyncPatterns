//
//  RxCheeseFactory.swift
//  AsyncPatterns
//
//  Created by Wojciech Chojnacki on 14/11/2016.
//  Copyright © 2016 Memrise. All rights reserved.
//

import Foundation
import RxSwift

class RxCheeseFactory {
    
    func pasterise(milk:Milk) -> Observable<Milk> {
        guard !milk.pasterised else {
            return Observable.error(SpoiledProductError())
        }
        return Observable.create { o in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                o.onNext(Milk(pasterised: true))
                o.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func inoculate(milk:Milk, bacteria:Bacteria) -> Observable<(Curd, Whey)> {
        guard milk.pasterised else {
            return Observable.error(SpoiledProductError())
        }
        
        return Observable.create { o in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                o.onNext((Curd(), Whey()))
                o.onCompleted()
            }
        
            return Disposables.create()
        }
    }
    
    func texture(curd:Curd) -> Observable<(CurdBlock, Whey)> {
        return Observable.create { o in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                o.onNext((CurdBlock(salted: false), Whey()))
                o.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func salt(curd:CurdBlock) -> Observable<CurdBlock> {
        guard !curd.salted else {
            return Observable.error(SpoiledProductError())
        }
        
        return Observable.create { o in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                o.onNext(CurdBlock(salted: true))
                o.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func age(curd:CurdBlock) -> Observable<CheeseBlock> {
        guard curd.salted else {
            return Observable.error(SpoiledProductError())
        }
        
        return Observable.create { o in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                o.onNext(CheeseBlock(age: 2))
                o.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func age(cheese:CheeseBlock) -> Observable<CheeseBlock>  {
        return Observable.create { o in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                o.onNext(CheeseBlock(age: cheese.age + 2))
                o.onCompleted()
            }
            return Disposables.create()
        }
    }
}

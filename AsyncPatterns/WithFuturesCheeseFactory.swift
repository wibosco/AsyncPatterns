//
//  WithFuturesCheeseFactory.swift
//  AsyncPatterns
//
//  Created by Wojciech Chojnacki on 14/11/2016.
//  Copyright © 2016 Memrise. All rights reserved.
//

import Foundation
import BrightFutures

class WithFuturesCheeseFactory {
    
    func pasterise(milk:Milk) -> Future<Milk, SpoiledProductError> {
        guard !milk.pasterised else {
            return Future(error: SpoiledProductError())
        }
        
        let promise = Promise<Milk, SpoiledProductError>()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            promise.success(Milk(pasterised: true))
        }
        
        return promise.future
    }
    
    func inoculate(milk:Milk, bacteria:Bacteria) -> Future<(Curd, Whey), SpoiledProductError> {
        guard milk.pasterised else {
            return Future(error: SpoiledProductError())
        }
        
        let promise = Promise<(Curd, Whey), SpoiledProductError>()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            promise.success((Curd(), Whey()))
        }
        
        return promise.future
    }
    
    func texture(curd:Curd) -> Future<(CurdBlock, Whey), SpoiledProductError> {
        let promise = Promise<(CurdBlock, Whey), SpoiledProductError>()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            promise.success((CurdBlock(salted: false), Whey()))
        }
        return promise.future
    }
    
    func salt(curd:CurdBlock) -> Future<CurdBlock, SpoiledProductError> {
        guard !curd.salted else {
            return Future(error: SpoiledProductError())
        }
        
        let promise = Promise<CurdBlock, SpoiledProductError>()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            promise.success(CurdBlock(salted: true))
        }
        return promise.future
    }
    
    func age(curd:CurdBlock) -> Future<CheeseBlock, SpoiledProductError> {
        guard curd.salted else {
            return Future(error: SpoiledProductError())
        }
        
        let promise = Promise<CheeseBlock, SpoiledProductError>()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            promise.success(CheeseBlock(age: 2))
        }
        
        return promise.future
    }
    
    func age(cheese:CheeseBlock) -> Future<CheeseBlock, SpoiledProductError>  {
        let promise = Promise<CheeseBlock, SpoiledProductError>()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            promise.success(CheeseBlock(age: cheese.age + 2))
        }
        return promise.future
    }
}

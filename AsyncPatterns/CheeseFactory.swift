//
//  CheeseFactory.swift
//  AsyncPatterns
//
//  Created by Wojciech Chojnacki on 08/11/2016.
//  Copyright © 2016 chojnac.com All rights reserved.
//

import Foundation
import Dispatch


class CheeseFactory: CheeseProcess {
    func pasterise(milk:Milk, complete:@escaping ((Milk?, Error?)->Void)) {
        guard !milk.pasterised else {
            complete(nil, SpoiledProductError())
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            complete(Milk(pasterised: true), nil)
        }
    }
    func inoculate(milk:Milk, bacteria:Bacteria, complete:@escaping (((Curd, Whey)?, Error?)->Void)) {
        guard milk.pasterised else {
            complete(nil, SpoiledProductError())
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            complete((Curd(), Whey()), nil)
        }
    }
    
    func texture(curd:Curd, complete:@escaping (((CurdBlock, Whey)?, Error?)->Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            complete((CurdBlock(salted: false), Whey()), nil)
        }
    }
    
    func salt(curd:CurdBlock, complete:@escaping ((CurdBlock?, Error?)->Void)) {
        guard !curd.salted else {
            complete(nil, SpoiledProductError())
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            complete(CurdBlock(salted: true), nil)
        }
    }
    
    func age(curd:CurdBlock, complete:@escaping ((CheeseBlock?, Error?)->Void)) {
        guard curd.salted else {
            complete(nil, SpoiledProductError())
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            complete(CheeseBlock(age: 2), nil)
        }
    }
    
    func age(cheese:CheeseBlock, complete:@escaping ((CheeseBlock?, Error?)->Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            complete(CheeseBlock(age: cheese.age + 2), nil)
        }
    }
    
}


//
//  CheesFactory.swift
//  AsyncPatterns
//
//  Created by Wojciech Chojnacki on 08/11/2016.
//  Copyright © 2016 chojnac.com All rights reserved.
//

import Foundation

protocol Ingridient {
    
}

struct Milk:Ingridient {
    let pasterised: Bool
}

struct Bacteria:Ingridient {
    
}

struct Salt:Ingridient {
    
}

struct Curd {
}

struct CurdBlock {
    let salted: Bool
}

struct Whey {
    
}

struct CheeseBlock {
    let age: Int //months
    
    func ready()->Bool {
        return age > 6
    }
}

struct SpoiledProductError: Error {
    
}


protocol CheeseProcess {
    func pasterise(milk:Milk, complete:@escaping ((Milk?, Error?)->Void))
    func inoculate(milk:Milk, bacteria:Bacteria, complete:@escaping (((Curd, Whey)?, Error?)->Void))
    func texture(curd:Curd, complete:@escaping (((CurdBlock, Whey)?, Error?)->Void))
    func salt(curd:CurdBlock, complete:@escaping ((CurdBlock?, Error?)->Void))
    func age(curd:CurdBlock, complete:@escaping ((CheeseBlock?, Error?)->Void))
    func age(cheese:CheeseBlock, complete:@escaping ((CheeseBlock?, Error?)->Void))
}





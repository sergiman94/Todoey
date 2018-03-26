//
//  Category.swift
//  Todoey
//
//  Created by Sergio Manrique on 3/23/18.
//  Copyright © 2018 Clever.Inc. All rights reserved.
//

import Foundation
import RealmSwift



class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}






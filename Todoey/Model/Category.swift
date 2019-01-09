//
//  Category.swift
//  Todoey
//
//  Created by malygam on 09/01/2019.
//  Copyright © 2019 Matthieu Malyga. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}

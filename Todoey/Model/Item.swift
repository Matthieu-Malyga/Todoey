//
//  Item.swift
//  Todoey
//
//  Created by malygam on 09/01/2019.
//  Copyright © 2019 Matthieu Malyga. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

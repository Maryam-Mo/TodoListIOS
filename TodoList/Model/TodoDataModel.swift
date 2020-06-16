//
//  TodoDataModel.swift
//  TodoList
//
//  Created by Maryam on 4/28/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import Foundation
import RealmSwift

class TodoDataModel: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var status: String = StatusEnum.NEW.rawValue
    @objc dynamic var createdIn: String  = ""
    var parentCategory = LinkingObjects(fromType: CategoryDataModel.self, property: "items")
}

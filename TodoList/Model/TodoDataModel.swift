//
//  TodoDataModel.swift
//  TodoList
//
//  Created by Maryam on 4/28/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import Foundation

class TodoDataModel {
    
    var id: Int?
    var name: String
    var status: String
    var category: CategoryDataModel?


    init(id: Int, name: String, status: String, category: CategoryDataModel) {
        self.id = id
        self.name = name
        self.status = status
        self.category = category
    }

    init(name: String, status: String, category: CategoryDataModel) {
        self.name = name
        self.status = status
        self.category = category
    }
    
    init(name: String, status: String) {
        self.name = name
        self.status = status
    }
}

//
//  CategoryDataModel.swift
//  TodoList
//
//  Created by Maryam on 4/28/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import UIKit

class CategoryDataModel{
    
    var id: Int?
    var name: String
    var user: UserDataModel
    
    
    init(id: Int, name: String, user: UserDataModel) {
        self.id = id
        self.name = name
        self.user = user
    }
    
    init(name: String, user: UserDataModel) {
        self.name = name
        self.user = user
    }
}

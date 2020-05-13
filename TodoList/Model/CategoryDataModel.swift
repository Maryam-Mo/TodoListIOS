//
//  CategoryDataModel.swift
//  TodoList
//
//  Created by Maryam on 4/28/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryDataModel: Object{
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    let items = List<TodoDataModel>()

}

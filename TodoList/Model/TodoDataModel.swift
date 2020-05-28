//
//  TodoDataModel.swift
//  TodoList
//
//  Created by Maryam on 4/28/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import Foundation

class TodoDataModel {
    
    var name: String = ""
    var status: String = Status.StatusEnum.NEW.rawValue
    var createdIn: String  = ""
    var categoryName: String = ""
}

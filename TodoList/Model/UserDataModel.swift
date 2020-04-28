//
//  UserDataModel.swift
//  TodoList
//
//  Created by Maryam on 3/30/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import UIKit

class UserDataModel{
    
    var id: Int?
    var firstName: String
    var lastName: String
    var contactNo: String
    var userName: String
    var password: String
    
    
    init(id: Int, firstName: String, lastName: String, contactNo: String, userName: String, password: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.contactNo = contactNo
        self.userName = userName
        self.password = password
    }
}



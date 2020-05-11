//
//  UserDataModel.swift
//  TodoList
//
//  Created by Maryam on 3/30/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class UserDataModel : Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var contactNo: String = ""
    @objc dynamic var userName: String = ""
    @objc dynamic var password: String = ""
    
//    required convenience init?(map: Map) {
//        self.init()
//    }

//    func mapping(map: Map) {
//        id <- map["id"]
//        firstName <- map["firstName"]
//        lastName <- map["lastName"]
//        contactNo <- map["contactNo"]
//        userName <- map["userName"]
//        password <- map["password"]
//    }
    
    
//    init(id: Int, firstName: String, lastName: String, contactNo: String, userName: String, password: String) {
//        self.id = id
//        self.firstName = firstName
//        self.lastName = lastName
//        self.contactNo = contactNo
//        self.userName = userName
//        self.password = password
//    }
}

//public protocol Mappable {
//    init?(map: Map)
//    mutating func mapping(map: Map)
//}



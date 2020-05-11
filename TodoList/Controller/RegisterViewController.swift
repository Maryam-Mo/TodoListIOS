//
//  RegisterViewController.swift
//  TodoList
//
//  Created by Maryam on 4/7/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var contactNoTxt: UITextField!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLbl.isHidden = true
    }
        
    @IBAction func save(_ sender: Any) {
        
        errorLbl.isHidden = true
        
        guard let firstName = firstNameTxt.text, firstNameTxt.text?.count != 0 else {
            errorLbl.isHidden = false
            errorLbl.text = "Please enter the firstName"
            return
        }
        guard let lastName = lastNameTxt.text, lastNameTxt.text?.count != 0 else {
            errorLbl.isHidden = false
            errorLbl.text = "Please enter the lastName"
            return
        }
        guard let contactNo = contactNoTxt.text, contactNoTxt.text?.count != 0 else {
            errorLbl.isHidden = false
            errorLbl.text = "Please enter the contactNo"
            return
        }
        guard let userName = userNameTxt.text, userNameTxt.text?.count != 0 else {
            errorLbl.isHidden = false
            errorLbl.text = "Please enter the userName"
            return
        }
        guard let password = passwordTxt.text, passwordTxt.text?.count != 0 else {
            errorLbl.isHidden = false
            errorLbl.text = "Please enter the password"
            return
        }
        
        saveInRealm(firstName: firstName, lastName: lastName, contactNo: contactNo, userName: userName, password: password)

//        let url = "http://192.168.1.5:8080/api/user/register"
//
//        let json = [
//            "firstName": "\(firstNameTxt.text)",
//            "lastName": "\(lastNameTxt.text)",
//            "contactNo": "\(contactNoTxt.text)",
//            "userName": "\(userNameTxt.text)",
//            "password": "\(passwordTxt.text)"
//        ]
//
//        Alamofire.request(url, method: .post, parameters: json, encoding: JSONEncoding.default, headers: [:]).responseJSON {
//                    response in
//                    switch (response.result) {
//                    case .success:
//                    self.performSegue(withIdentifier: "openLoginPage", sender: self)
//                    case .failure:
//                        print(Error.self)
//                    }
//                }
        }

    
    //MARK: - Data Manipulation Methods
    func saveInRealm(firstName: String, lastName: String, contactNo: String, userName: String, password: String) {
        do {
            try realm.write{
                realm.create(UserDataModel.self, value: [0, firstName, lastName, contactNo, userName , password])
            }
            self.performSegue(withIdentifier: "openLoginPage", sender: self)
        } catch {
            print("Error saving user \(error)")
        }
    }
    
}
    

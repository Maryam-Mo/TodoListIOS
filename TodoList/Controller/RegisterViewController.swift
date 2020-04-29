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

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var contactNoTxt: UITextField!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLbl.isHidden = true
    }
        
    @IBAction func save(_ sender: Any) {
        
        errorLbl.isHidden = true
        
        validateFirstName()
        validateLastName()
        validateContactNo()
        validateUserName()
        validatePassword()

        let url = "http://192.168.1.5:8080/api/user/register"

        let json = [
            "firstName": "\(firstNameTxt.text)",
            "lastName": "\(lastNameTxt.text)",
            "contactNo": "\(contactNoTxt.text)",
            "userName": "\(userNameTxt.text)",
            "password": "\(passwordTxt.text)"
        ]
                
        Alamofire.request(url, method: .post, parameters: json, encoding: JSONEncoding.default, headers: [:]).responseJSON {
                    response in
                    switch (response.result) {
                    case .success:
                    self.performSegue(withIdentifier: "openLoginPage", sender: self)
                    case .failure:
                        print(Error.self)
                    }
                }
        }
    
    func validateFirstName() {
        guard let firstName = firstNameTxt.text, firstNameTxt.text?.count != 0 else {
            errorLbl.isHidden = false
            errorLbl.text = "Please enter the firstName"
            return
        }
    }
    
    func validateLastName() {
        guard let lastName = lastNameTxt.text, lastNameTxt.text?.count != 0 else {
            errorLbl.isHidden = false
            errorLbl.text = "Please enter the lastName"
            return
        }
    }
    
    func validateContactNo() {
        guard let contactNo = contactNoTxt.text, contactNoTxt.text?.count != 0 else {
            errorLbl.isHidden = false
            errorLbl.text = "Please enter the contactNo"
            return
        }
    }
    
    func validateUserName() {
        guard let userName = userNameTxt.text, userNameTxt.text?.count != 0 else {
            errorLbl.isHidden = false
            errorLbl.text = "Please enter the userName"
            return
        }
    }
    
    func validatePassword() {
        guard let password = passwordTxt.text, passwordTxt.text?.count != 0 else {
            errorLbl.isHidden = false
            errorLbl.text = "Please enter the password"
            return
        }
    }
    
}

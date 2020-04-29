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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
        
    @IBAction func save(_ sender: Any) {
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
    
}

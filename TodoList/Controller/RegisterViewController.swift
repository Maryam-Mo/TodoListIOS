//
//  RegisterViewController.swift
//  TodoList
//
//  Created by Maryam on 4/7/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import UIKit

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
        let session = URLSession.shared
        let url = URL(string: "http://192.168.1.9:8080/api/user/register")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let json = [
            "firstName": "\(firstNameTxt.text)",
            "lastName": "\(lastNameTxt.text)",
            "contactNo": "\(contactNoTxt.text)",
            "userName": "\(userNameTxt.text)",
            "password": "\(passwordTxt.text)"
        ]
        
        print(json)
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])

        let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                let alert = UIAlertController(title: "Resigter", message: "The user is registered!", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                self.present(alert, animated: true, completion: nil)
            }        }

        task.resume()
        
    }
    
    
}

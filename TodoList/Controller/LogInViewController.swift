//
//  ViewController.swift
//  TodoList
//
//  Created by Maryam on 2/19/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // Mark: Properties
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLbl.isHidden = true
    }
    

    @IBAction func login(_ sender: UIButton) {

        errorLbl.isHidden = true

        validateUserName()
        validatePassword()

//
//        performSegue(withIdentifier: "openCategoryPage", sender: self)
        
    
        let session = URLSession.shared
        let url = URL(string: "http://192.168.1.5:8080/api/user/login")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let json = [
            "userName": "\(userNameTxt.text)",
            "password": "\(passwordTxt.text)"
        ]

        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])

        let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
//                    let responseInfo = try JSONDecoder().decode(loginResponse.self, from: data)
                    print(dataString)
                    let alert = UIAlertController(title: "Login", message: "You are login now!", preferredStyle: UIAlertController.Style.alert)


                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                    self.present(alert, animated: true, completion: nil)
            }
            
        }

        task.resume()
    }
    
    func validateUserName() {
        guard let userName = userNameTxt.text, userNameTxt.text?.count != 0 else {
            errorLbl.isHidden = false
            errorLbl.text = "Please enter your username"
            return
        }
    }
    
    func validatePassword() {
        guard let password = passwordTxt.text, passwordTxt.text?.count != 0 else {
            errorLbl.isHidden = false
            errorLbl.text = "Please enter your password"
            return
        }
    }
    
    
    @IBAction func register(_ sender: Any) {
        performSegue(withIdentifier: "openRegisterPage", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let user = UserDataModel(id: 1, firstName: "aa", lastName: "bb", contactNo: "123", userName: "admin", password: "admin")
        print(user.firstName)

        if segue.identifier == "openCategoryPage" {
            if let target = segue.destination as? CategoryViewController {
                target.user = user
            }
        }
    }
}




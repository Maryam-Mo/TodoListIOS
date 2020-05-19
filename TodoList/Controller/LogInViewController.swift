//
//  ViewController.swift
//  TodoList
//
//  Created by Maryam on 2/19/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    let realm = try! Realm()
    var loginUser: [UserDataModel]?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLbl.isHidden = true
        userNameTxt.layer.shadowColor = UIColor.black.cgColor
        userNameTxt.layer.shadowOffset = CGSize(width: 2, height: 2)
        userNameTxt.layer.shadowRadius = 2
        userNameTxt.layer.shadowOpacity = 1.0
        passwordTxt.layer.shadowColor = UIColor.black.cgColor
        passwordTxt.layer.shadowOffset = CGSize(width: 2, height: 2)
        passwordTxt.layer.shadowRadius = 2
        passwordTxt.layer.shadowOpacity = 1.0
        
        loginBtn.layer.shadowColor = UIColor.black.cgColor
        loginBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
        loginBtn.layer.shadowRadius = 5
        loginBtn.layer.shadowOpacity = 1.0
        registerBtn.layer.shadowColor = UIColor.black.cgColor
        registerBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
        registerBtn.layer.shadowRadius = 5
        registerBtn.layer.shadowOpacity = 1.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearTextFields()
        DispatchQueue.main.async {
            self.passwordTxt.resignFirstResponder()
        }
    }

    @IBAction func login(_ sender: UIButton) {

        errorLbl.isHidden = true

        validateUserName()
        validatePassword()

        login()
                
    
//        let session = URLSession.shared
//        let url = URL(string: "http://192.168.1.5:8080/api/user/login")!
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let json = [
//            "userName": "\(userNameTxt.text)",
//            "password": "\(passwordTxt.text)"
//        ]
//
//        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
//
//        let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
//            if let data = data, let dataString = String(data: data, encoding: .utf8) {
////                    let responseInfo = try JSONDecoder().decode(loginResponse.self, from: data)
//                    print(dataString)
//                    let alert = UIAlertController(title: "Login", message: "You are login now!", preferredStyle: UIAlertController.Style.alert)
//
//
//                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//
//                    self.present(alert, animated: true, completion: nil)
//            }
//
//        }
//
//        task.resume()
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
    
    func login() {
        let predicate = NSPredicate(format: "userName = %@ AND password = %@", userNameTxt.text!, passwordTxt.text!)
        loginUser = realm.objects(UserDataModel.self).filter(predicate).array
        if loginUser != nil {
            let alert = UIAlertController(title: "Login", message: "You are now login!", preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                self.performSegue(withIdentifier: "openCategoryPage", sender: self)
             }))
             self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Login", message: "The username or password is not correct!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func register(_ sender: Any) {
        performSegue(withIdentifier: "openRegisterPage", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openCategoryPage" {
            if let target = segue.destination as? CategoryViewController {
                target.user = loginUser![0]
            }
        }
    }
    
    func clearTextFields() {
        userNameTxt.text = ""
        passwordTxt.text = ""
    }
}

extension Results {
    
    var array: [Element]? {
        return self.count > 0 ? self.map { $0 } : nil
    }
}




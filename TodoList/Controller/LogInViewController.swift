//
//  ViewController.swift
//  TodoList
//
//  Created by Maryam on 2/19/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        errorLbl.isHidden = true
        createShadows()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearTextFields()
        DispatchQueue.main.async {
            self.passwordTxt.resignFirstResponder()
        }
    }
    
    fileprivate func createShadows() {
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
    }

    @IBAction func login(_ sender: UIButton) {
        loginBtn.isEnabled = false
        SVProgressHUD.show()
        
        errorLbl.isHidden = true

        guard let userName = userNameTxt.text, userNameTxt.text?.count != 0 else {
            SVProgressHUD.dismiss()
            loginBtn.isEnabled = true
            errorLbl.isHidden = false
            errorLbl.text = "Please enter your username"
            return
        }
        guard let password = passwordTxt.text, passwordTxt.text?.count != 0 else {
            SVProgressHUD.dismiss()
            loginBtn.isEnabled = true
            errorLbl.isHidden = false
            errorLbl.text = "Please enter your password"
            return
        }

        login(userName: userName, password: password)
                
    }
    
    func login(userName: String, password: String) {
        Auth.auth().signIn(withEmail: userName, password: password) { (user, error) in
            if error != nil {
                let alert = UIAlertController(title: "Login", message: "The username or password is not correct!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                SVProgressHUD.dismiss()
                self.loginBtn.isEnabled = true
                self.present(alert, animated: true, completion: nil)
                
            } else {
                let alert = UIAlertController(title: "Login", message: "You are now login!", preferredStyle: UIAlertController.Style.alert)
                 alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                    self.performSegue(withIdentifier: "openCategoryPage", sender: self)
                    self.loginBtn.isEnabled = true
                 }))
                self.present(alert, animated: true, completion: nil)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func clearTextFields() {
        userNameTxt.text = ""
        passwordTxt.text = ""
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}




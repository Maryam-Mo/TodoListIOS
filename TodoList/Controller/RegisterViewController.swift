//
//  RegisterViewController.swift
//  TodoList
//
//  Created by Maryam on 4/7/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var contactNoTxt: UITextField!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        errorLbl.isHidden = true
        createShadows()
    }
    
    fileprivate func createShadows() {
        firstNameTxt.layer.shadowColor = UIColor.black.cgColor
        firstNameTxt.layer.shadowOffset = CGSize(width: 2, height: 2)
        firstNameTxt.layer.shadowRadius = 2
        firstNameTxt.layer.shadowOpacity = 1.0
        lastNameTxt.layer.shadowColor = UIColor.black.cgColor
        lastNameTxt.layer.shadowOffset = CGSize(width: 2, height: 2)
        lastNameTxt.layer.shadowRadius = 2
        lastNameTxt.layer.shadowOpacity = 1.0
        contactNoTxt.layer.shadowColor = UIColor.black.cgColor
        contactNoTxt.layer.shadowOffset = CGSize(width: 2, height: 2)
        contactNoTxt.layer.shadowRadius = 2
        contactNoTxt.layer.shadowOpacity = 1.0
        userNameTxt.layer.shadowColor = UIColor.black.cgColor
        userNameTxt.layer.shadowOffset = CGSize(width: 2, height: 2)
        userNameTxt.layer.shadowRadius = 2
        userNameTxt.layer.shadowOpacity = 1.0
        passwordTxt.layer.shadowColor = UIColor.black.cgColor
        passwordTxt.layer.shadowOffset = CGSize(width: 2, height: 2)
        passwordTxt.layer.shadowRadius = 2
        passwordTxt.layer.shadowOpacity = 1.0
        saveBtn.layer.shadowColor = UIColor.black.cgColor
        saveBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
        saveBtn.layer.shadowRadius = 5
        saveBtn.layer.shadowOpacity = 1.0
    }
        
    @IBAction func save(_ sender: Any) {
        saveBtn.isEnabled = false
        SVProgressHUD.show()
        
        errorLbl.isHidden = true
        
        guard let firstName = firstNameTxt.text, firstNameTxt.text?.count != 0 else {
            SVProgressHUD.dismiss()
            saveBtn.isEnabled = true
            errorLbl.isHidden = false
            errorLbl.text = "Please enter the firstName"
            return
        }
        guard let lastName = lastNameTxt.text, lastNameTxt.text?.count != 0 else {
            SVProgressHUD.dismiss()
            saveBtn.isEnabled = true
            errorLbl.isHidden = false
            errorLbl.text = "Please enter the lastName"
            return
        }
        guard let contactNo = contactNoTxt.text, contactNoTxt.text?.count != 0 else {
            SVProgressHUD.dismiss()
            saveBtn.isEnabled = true
            errorLbl.isHidden = false
            errorLbl.text = "Please enter the contactNo"
            return
        }
        guard let userName = userNameTxt.text, userNameTxt.text?.count != 0 else {
            SVProgressHUD.dismiss()
            saveBtn.isEnabled = true
            errorLbl.isHidden = false
            errorLbl.text = "Please enter the userName"
            return
        }
        guard let password = passwordTxt.text, passwordTxt.text?.count != 0 else {
            SVProgressHUD.dismiss()
            saveBtn.isEnabled = true
            errorLbl.isHidden = false
            errorLbl.text = "Please enter the password"
            return
        }
        
        saveInFirebase(userName: userName, password: password)
    }

    
    //MARK: - Data Manipulation Methods
    func saveInFirebase(userName: String, password: String) {
        Auth.auth().createUser(withEmail: userName, password: password) { (user, error) in
            if error != nil {
                SVProgressHUD.dismiss()
                self.saveBtn.isEnabled = true
                print("Error saving user \(error)")
            } else {
               let alert = UIAlertController(title: "Register", message: "You are now registered!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                self.navigationController?.popToRootViewController(animated: true)
                    self.saveBtn.isEnabled = true

                    }))
                self.present(alert, animated: true, completion: nil)
                SVProgressHUD.dismiss()
            }
        }
    }
    
}
    

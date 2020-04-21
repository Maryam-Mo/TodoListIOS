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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func login(_ sender: UIButton) {
        let session = URLSession.shared
        let url = URL(string: "http://192.168.1.12:8080/api/user/login")!

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
                let alert = UIAlertController(title: "Login", message: "You are login now!", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                self.present(alert, animated: true, completion: nil)
            }        }

        task.resume()
    }
    
    
    @IBAction func register(_ sender: Any) {
        performSegue(withIdentifier: "openRegisterPage", sender: self)
        
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "openRegisterPage" {
//            let destination = segue.destination as! RegisterViewController
//        }
//    }
}


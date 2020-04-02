//
//  ViewController.swift
//  TodoList
//
//  Created by Maryam on 2/19/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Mark: Properties
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func login(_ sender: UIButton) {
        let session = URLSession.shared
        let url = URL(string: "http://localhost:3306/api/user/login")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let json = [
            "userName": "admin",
            "password": "admin"
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
}


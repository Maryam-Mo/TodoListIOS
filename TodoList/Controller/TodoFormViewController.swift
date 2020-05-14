//
//  TodoFormViewController.swift
//  TodoList
//
//  Created by Maryam on 4/28/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import UIKit
import RealmSwift

class TodoFormViewController: UIViewController {
    
    let realm = try! Realm()

    @IBOutlet weak var nameTxt: UITextField!
    
    var delegate : CanRecieveDelegate?
    var todo: TodoDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentTodo = todo {
            nameTxt.text = currentTodo.name
        }
    }

    @IBAction func create(_ sender: Any) {
        if let updatedTodo = todo {
            do {
                try realm.write() {
                    updatedTodo.name = nameTxt.text!
                    updatedTodo.status = todo!.status
                }
                delegate?.todoReceived(todo: updatedTodo)
                self.navigationController?.popViewController(animated: true)

            } catch {
                print("Error in updating the todo, \(error)")
            }
        }
    }

}


protocol CanRecieveDelegate {
    func todoReceived(todo: TodoDataModel)
}

//
//  TodoFormViewController.swift
//  TodoList
//
//  Created by Maryam on 4/28/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import UIKit

class TodoFormViewController: UIViewController {

    @IBOutlet weak var nameTxt: UITextField!
    
    var todo: TodoDataModel?
    var delegate : CanRecieveDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedTodo = todo {
            nameTxt.text = selectedTodo.name
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    */

    @IBAction func create(_ sender: Any) {
        if let currentTodo = todo {
            currentTodo.name = nameTxt.text!
            delegate?.todoReceived(todo: currentTodo)
        } else {
            let currentTodo = TodoDataModel()
            currentTodo.name = nameTxt.text!
            delegate?.todoReceived(todo: currentTodo)
        }
        self.dismiss(animated: true, completion: nil)
    }

}


protocol CanRecieveDelegate {
    func todoReceived(todo: TodoDataModel)
}

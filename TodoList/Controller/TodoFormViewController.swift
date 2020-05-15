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
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    let realm = try! Realm()

    @IBOutlet weak var nameTxt: UITextField!
    
    var delegate : CanRecieveDelegate?
    var todo: TodoDataModel?
    var statuses: [String] = [Status.StatusEnum.IN_PROGRESS.rawValue, Status.StatusEnum.COMPLETED.rawValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentTodo = todo {
            nameTxt.text = currentTodo.name
            locationLbl.text! += "\n" + currentTodo.createdIn
        }
        picker.delegate = self
        picker.dataSource = self
    }

    @IBAction func create(_ sender: Any) {
        if let updatedTodo = todo {
            do {
                try realm.write() {
                    updatedTodo.name = nameTxt.text!
                    print(picker.selectedRow(inComponent: 0))
                    updatedTodo.status = statuses[picker.selectedRow(inComponent: 0)]
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

extension TodoFormViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statuses[row]
    }

}

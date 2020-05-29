//
//  TodoFormViewController.swift
//  TodoList
//
//  Created by Maryam on 4/28/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import UIKit
import Firebase

class TodoFormViewController: UIViewController {
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var nameTxt: UITextField!
    
    var delegate : CanRecieveDelegate?
    var todo: TodoDataModel?
    var statuses: [String] = [Status.StatusEnum.IN_PROGRESS.rawValue, Status.StatusEnum.COMPLETED.rawValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        guard let currentTodo = todo else {
            fatalError("No todo is selected!")
        }
        nameTxt.text = currentTodo.name
        locationLbl.text! += "\n" + currentTodo.createdIn
        picker.delegate = self
        picker.dataSource = self
        
        picker.layer.shadowColor = UIColor.black.cgColor
        picker.layer.shadowOffset = CGSize(width: 2, height: 2)
        picker.layer.shadowRadius = 2
        picker.layer.shadowOpacity = 1.0
        nameTxt.layer.shadowColor = UIColor.black.cgColor
        nameTxt.layer.shadowOffset = CGSize(width: 2, height: 2)
        nameTxt.layer.shadowRadius = 2
        nameTxt.layer.shadowOpacity = 1.0
        saveBtn.layer.shadowColor = UIColor.black.cgColor
        saveBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
        saveBtn.layer.shadowRadius = 5
        saveBtn.layer.shadowOpacity = 1.0
    }

    @IBAction func create(_ sender: Any) {
        Firestore.firestore().collection("todo").document(todo!.name).updateData(["name": nameTxt.text!, "status" : statuses[picker.selectedRow(inComponent: 0)]]) { (error) in
            if error != nil {
                print("Error in updating todo \(error)")
            } else {
                self.todo!.name = self.nameTxt.text!
                self.todo!.status = self.statuses[self.picker.selectedRow(inComponent: 0)]
                self.delegate?.todoReceived(todo: self.todo!)
                self.navigationController?.popViewController(animated: true)            }
        }
    }

}


protocol CanRecieveDelegate {
    func todoReceived(todo: TodoDataModel)
}

// MARK: - PickerView Datasources Mathods
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

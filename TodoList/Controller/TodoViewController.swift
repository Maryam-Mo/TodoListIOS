//
//  TodoViewController.swift
//  TodoList
//
//  Created by Maryam on 4/28/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import UIKit
import RealmSwift

class TodoViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var todos: [TodoDataModel]?
    var selectedTodo: TodoDataModel?
    var selectedCategory: CategoryDataModel? {
       didSet {
        reloadData()
       }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let todo = TodoDataModel()
                        todo.name = textField.text!
                        todo.status = Status.StatusEnum.NEW.rawValue
                        currentCategory.items.append(todo)
                    }
                    self.reloadData()
                } catch {
                    print("Error in saving new todo \(error)")
                }
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new Todo"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Data Manipulation Methods
    func save(todo: TodoDataModel) {
        do {
            try realm.write {
                realm.add(todo)
            }
            reloadData()
        } catch {
            print("Error saving todo \(error)")
        }
    }
            
    func reloadData() {
        todos = realm.objects(TodoDataModel.self).array
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todos?[indexPath.row]{
            do {
                try realm.write() {
                    realm.delete(item)
                }
                reloadData()
            } catch {
                print("The selected todo can't be deleted, \(error)")
            }
        }
    }
}

extension TodoViewController: CanRecieveDelegate {
    func todoReceived(todo: TodoDataModel) {
        reloadData()
    }
}

extension TodoViewController {
    // MARK: - Tableview Datasources Mathods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let todo = todos?[indexPath.row] {
            cell.textLabel?.text = todo.name
        } else {
           cell.textLabel?.text = "No Items Added Yet"
        }
        return cell
    }
    // MARK: - Tableview Delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTodo = todos?[indexPath.row]
        performSegue(withIdentifier: "openAddTodoPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openAddTodoPage" {
            let target = segue.destination as? TodoFormViewController
            if selectedTodo != nil {
                target?.todo = selectedTodo
            }
            target?.delegate = self
        }
    }

}

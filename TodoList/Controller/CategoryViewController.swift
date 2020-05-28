//
//  CategoryViewController.swift
//  TodoList
//
//  Created by Maryam on 4/22/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import UIKit
import Firebase

class CategoryViewController: SwipeTableViewController {
        
    var categories: [CategoryDataModel]?
    var selectedCategory: CategoryDataModel?
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        ref = Database.database().reference().child("category")
        loadCategories()
        tableView.separatorStyle = .none
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            self.save(name: textField.text!)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
        //MARK: - Data Manipulation Methods
    func save(name: String) {
            let categoryDictionary = ["name": name]
        ref!.child(name.lowercased()).setValue(categoryDictionary) {
                (error, reference) in
                if error != nil {
                    print("Error saving category \(error)")
                } else {
                    self.loadCategories()
                }
            }
        }
        
        func loadCategories() {
            var newCategories: [CategoryDataModel] = []
            ref!.observe(.value, with: { snapshot in
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot {
                         let snapshotValue = snapshot.value as! Dictionary<String, String>
                         let name = snapshotValue["name"]!
                         let category = CategoryDataModel()
                         category.name = name
                         newCategories.append(category)
                  }
                }
                self.categories = newCategories
                self.tableView.reloadData()
            })
        }
        
        override func updateModel(at indexPath: IndexPath) {
            guard let category = categories?[indexPath.row] else {
                fatalError("Selected category doesn't exist!")
            }
            ref!.child(category.name.lowercased()).removeValue { error, _ in
                   print(error)
               }
            loadCategories()
        }
    }



//MARK: - TableView Datasource Methods
extension CategoryViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
        }
        return cell
    }

    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let exist = categories?[indexPath.row] {
            selectedCategory = exist
            performSegue(withIdentifier: "openTodoPage", sender: self)
        }
    }
    
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
            if segue.identifier == "openTodoPage" {
                if let target = segue.destination as? TodoViewController {
                    target.selectedCategory = selectedCategory
                }
            }
        }

}





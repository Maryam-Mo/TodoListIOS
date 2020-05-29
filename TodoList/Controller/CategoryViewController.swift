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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
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
        Firestore.firestore().collection("category").document(name).setData(["name": name]) { (error) in
            if error != nil {
                print("Error saving category \(error)")
            } else {
                self.loadCategories()
            }
        }
    }
        
        func loadCategories() {
            var newCategories: [CategoryDataModel] = []
            Firestore.firestore().collection("category").getDocuments { (snapshot, error) in
                if error == nil && snapshot != nil {
                    for document in snapshot!.documents {
                        let documentData = document.data()
                        let name = documentData["name"]!
                        let category = CategoryDataModel()
                        category.name = name as! String
                        newCategories.append(category)
                    }
                    self.categories = newCategories
                    self.tableView.reloadData()
                }
            }
        }
        
        override func updateModel(at indexPath: IndexPath) {
            guard let category = categories?[indexPath.row] else {
                fatalError("Selected category doesn't exist!")
            }
            Firestore.firestore().collection("category").document(category.name).delete { (error) in
                if error != nil {
                    print(error)
                } else {
                    self.loadCategories()
                }
            }
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





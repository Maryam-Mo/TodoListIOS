//
//  CategoryViewController.swift
//  TodoList
//
//  Created by Maryam on 4/22/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
        
    let realm = try! Realm()

    var categories: [CategoryDataModel]?
    var user: UserDataModel?
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
            let category = CategoryDataModel()
            category.name = textField.text!
            self.save(category: category)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
        //MARK: - Data Manipulation Methods
        func save(category: CategoryDataModel) {
            do {
                try realm.write{
                    realm.add(category)
                }
            } catch {
                print("Error saving category \(error)")
            }
            loadCategories()
        }
        
        func loadCategories() {
            categories = realm.objects(CategoryDataModel.self).array
            tableView.reloadData()
        }
        
        override func updateModel(at indexPath: IndexPath) {
            guard let category = categories?[indexPath.row] else {
                fatalError("Selected category doesn't exist!")
            }
            do {
                try realm.write {
                    realm.delete(category)
                }
                loadCategories()
            } catch {
                print("The selected category can't be deleted, \(error)")
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





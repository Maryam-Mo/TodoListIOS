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

//    var categoryArray = Results<CategoryDataModel>?
    var user: UserDataModel?
    var selectedCategory: CategoryDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        categoryArray.append(CategoryDataModel(name: "cat1", user: user!))

    }
    
//    @IBAction func create(_ sender: Any) {
//        let alert = UIAlertController(title: "Create a category", message: "Enter a name for the category", preferredStyle: .alert)
//
//        alert.addTextField()
//
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
//            let textField = alert?.textFields![0]
//            self.categoryArray.insert(CategoryDataModel(name: textField!.text!, user: self.user!), at: 0)
//            self.categoryTableView.beginUpdates()
//            self.categoryTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
//            self.categoryTableView.endUpdates()
//        }))
//
//        self.present(alert, animated: true, completion: nil)
////            self.categoryTableView.reloadData()
//
//
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "openTodoPage" {
            if let target = segue.destination as? TodoViewController {
                target.selectedCategory = self.selectedCategory
            }
        }
    }
    
}

//MARK: - TableView Datasource Methods
//extension CategoryViewController {
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return categoryArray?.count ?? 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
//        cell.textLabel?.text = categoryArray[indexPath.row].name
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        categoryArray.count
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedCategory = categoryArray[indexPath.row]
//        performSegue(withIdentifier: "openTodoPage", sender: self)
//    }
//
//}





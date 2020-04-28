//
//  CategoryViewController.swift
//  TodoList
//
//  Created by Maryam on 4/22/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    
    var categoryArray = [CategoryDataModel]()
    var user: UserDataModel?
    var selectedCategory: CategoryDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.categoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        categoryArray.append(CategoryDataModel(name: "cat1", user: user!))
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.reloadData()

    }
    
    @IBAction func create(_ sender: Any) {
        let alert = UIAlertController(title: "Create a category", message: "Enter a name for the category", preferredStyle: .alert)

        alert.addTextField()

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.categoryArray.insert(CategoryDataModel(name: textField!.text!, user: self.user!), at: 0)
            self.categoryTableView.beginUpdates()
            self.categoryTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
            self.categoryTableView.endUpdates()
        }))
        
        self.present(alert, animated: true, completion: nil)
//            self.categoryTableView.reloadData()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "openTodoPage" {
            if let target = segue.destination as? TodoViewController {
                target.selectedCategory = self.selectedCategory
            }
        }
    }
    
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categoryArray[indexPath.row]
        performSegue(withIdentifier: "openTodoPage", sender: self)
    }

}





//
//  TodoViewController.swift
//  TodoList
//
//  Created by Maryam on 4/28/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import UIKit

class TodoViewController: UIViewController {
    
    @IBOutlet weak var todoTableView: UITableView!
    
    var todoArray = [TodoDataModel]()
    var selectedCategory: CategoryDataModel?
    var createdTodo: TodoDataModel?
    var selectedTodo: TodoDataModel?
    var onUpdate: Bool = false
    var selectedTodoIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TodoCell")
        todoTableView.delegate = self
        todoTableView.dataSource = self
        todoTableView.reloadData()    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openAddTodoPage" {
            let target = segue.destination as? TodoFormViewController
            if selectedTodo != nil {
                target?.todo = selectedTodo
                onUpdate = true
                selectedTodo = nil
            }
            target?.delegate = self
        }
    }
    
    @IBAction func add(_ sender: Any) {
        performSegue(withIdentifier: "openAddTodoPage", sender: self)
    }
}

extension TodoViewController: CanRecieveDelegate {
    func todoReceived(todo: TodoDataModel) {
        self.createdTodo = todo
        if onUpdate {
            self.todoArray[selectedTodoIndex!] = self.createdTodo!
            self.todoTableView.reloadData()
            
        } else {
            self.todoArray.insert(createdTodo!, at: 0)
            self.todoTableView.beginUpdates()
            self.todoTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
            self.todoTableView.endUpdates()
        }
    }
}

extension TodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        cell.textLabel?.text = todoArray[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTodo = todoArray[indexPath.row]
        selectedTodoIndex = indexPath.row
        performSegue(withIdentifier: "openAddTodoPage", sender: self)
    }

}

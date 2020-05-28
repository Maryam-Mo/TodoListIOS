//
//  TodoViewController.swift
//  TodoList
//
//  Created by Maryam on 4/28/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class TodoViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var selectBtn: UIBarButtonItem!
    @IBOutlet weak var inProgressStatusBtn: UIBarButtonItem!
    @IBOutlet weak var completedStatusBtn: UIBarButtonItem!
    
    static let geoCoder = CLGeocoder()

    var location: String = ""
    let locationManager = CLLocationManager()
    var todos: [TodoDataModel]?
    var selectedTodo: TodoDataModel?
    var selectedTodos: [TodoDataModel]?
    var ref: DatabaseReference?
    var selectedCategory: CategoryDataModel? {
       didSet {
        ref = Database.database().reference().child("todo")
        reloadData()
       }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        inProgressStatusBtn.title = ""
        completedStatusBtn.title = ""
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        tableView.register(UINib(nibName: "TodoCell", bundle: nil), forCellReuseIdentifier: "customTodoCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = 80

    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let currentCategory = self.selectedCategory else {
                fatalError("No category is selected!")
            }
            self.save(name: textField.text!)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new Todo"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func selectButtonPressed(_ sender: UIBarButtonItem) {
        if selectBtn.title == "Select" {
            selectBtn.title = "Cancel"
            selectedTodos = []
            title = ""
            inProgressStatusBtn.title = "In Progress"
            completedStatusBtn.title = "Completed"
            tableView.allowsMultipleSelectionDuringEditing = true
            tableView.setEditing(true, animated: false)
        } else {
            selectBtn.title = "Select"
            title = selectedCategory?.name
            inProgressStatusBtn.title = ""
            completedStatusBtn.title = ""
            tableView.allowsMultipleSelectionDuringEditing = false
            tableView.setEditing(false, animated: false)
        }
    }
    
    @IBAction func inProgressStatusButtonPressed(_ sender: UIBarButtonItem) {
        selectBtn.title = "Select"
        title = selectedCategory?.name
        inProgressStatusBtn.title = ""
        completedStatusBtn.title = ""
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.setEditing(false, animated: false)
        if let todos = selectedTodos {
            for todo in todos {
                ref!.child(todo.name.lowercased()).updateChildValues(["status" : Status.StatusEnum.IN_PROGRESS.rawValue])
            }
            reloadData()
        } else {
            let alert = UIAlertController(title: "Please first select a row", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func completedStatusButtonPressed(_ sender: UIBarButtonItem) {
        selectBtn.title = "Select"
        title = selectedCategory?.name
        inProgressStatusBtn.title = ""
        completedStatusBtn.title = ""
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.setEditing(false, animated: false)
        if let todos = selectedTodos {
            for todo in todos {
                ref!.child(todo.name.lowercased()).updateChildValues(["status" : Status.StatusEnum.COMPLETED.rawValue])
            }
            reloadData()
        } else {
           let alert = UIAlertController(title: "Please first select a row", message: "", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Data Manipulation Methods
    func save(name: String) {
        let todoDictionary = ["name": name, "status": Status.StatusEnum.NEW.rawValue, "createdIn": location, "categoryName": selectedCategory!.name]
        ref!.child(name.lowercased()).setValue(todoDictionary) {
                (error, reference) in
                if error != nil {
                    print("Error saving todo \(error)")
                } else {
                    self.reloadData()
                }
            }
    }
            
    func reloadData() {
        var newTodos: [TodoDataModel] = []
        ref!.observe(.value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                    let snapshotValue = snapshot.value as! Dictionary<String, String>
                    if (snapshotValue["categoryName"]?.lowercased() == self.selectedCategory!.name.lowercased()) {
                        let todo = TodoDataModel()
                        todo.name = snapshotValue["name"]!
                        todo.status = snapshotValue["status"]!
                        todo.createdIn = snapshotValue["createdIn"]!
                        todo.categoryName = snapshotValue["categoryName"]!
                        newTodos.append(todo)
                    }
              }
            }
            self.todos = newTodos
            self.tableView.reloadData()
        })
    }
    
    //MARK: - Location Manager Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations[locations.count - 1] // Last location in this array is the most accurate one
        guard lastLocation.horizontalAccuracy > 0  else {
            fatalError("There is no accuracy!")
        }// As soon as the result has high accuracy we will stop updating the location
        locationManager.stopUpdatingLocation()
        let clLocation = CLLocation(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
        TodoViewController.geoCoder.reverseGeocodeLocation(clLocation) { placemarks, _ in
          guard let place = placemarks?.first else {
            fatalError("Can't find the location")
            }
            let result = "\(place)".split(separator: "@")
            self.location = String(result[0])
          }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Unavailable, \(error)")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTodoCell", for: indexPath) as! CustomTodoCell
        if let todo = todos?[indexPath.row] {
            cell.nameLbl.text = todo.name
            cell.statusLbl.text = todo.status
            cell.accessoryType = todo.status == Status.StatusEnum.COMPLETED.rawValue ? .checkmark : .disclosureIndicator
            if selectedCategory?.name.lowercased() == "home" {
                cell.avatarImageView.image = UIImage(named: "home")
            } else if selectedCategory?.name.lowercased() == "work" {
                cell.avatarImageView.image = UIImage(named: "work")
            } else if selectedCategory?.name.lowercased() == "shopping" {
                cell.avatarImageView.image = UIImage(named: "shopping")
            } else {
                cell.avatarImageView.image = UIImage(named: "todo")
            }
        } else {
           cell.nameLbl.text = "No Items Added Yet"
        }
        return cell
    }
    // MARK: - Tableview Delegate method
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            guard let item = self.todos?[indexPath.row] else {
                fatalError("Selected todo doesn't exist")
            }
            self.ref!.child(item.name.lowercased()).removeValue { error, _ in
                   print(error)
               }
            self.reloadData()
            completion(true)
        }
        action.image = UIImage(named: "delete-icon")
        return action
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTodo = todos?[indexPath.row]
        if (tableView.allowsMultipleSelectionDuringEditing) {
            if selectedTodo!.status != Status.StatusEnum.COMPLETED.rawValue {
                selectedTodos?.append(selectedTodo!)
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
                let alert = UIAlertController(title: "Can't update a completed todo", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        } else {
            if selectedTodo!.status != Status.StatusEnum.COMPLETED.rawValue {
                performSegue(withIdentifier: "openAddTodoPage", sender: self)
            } else {
                let alert = UIAlertController(title: "Can't update a completed todo", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
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

//MARK: - Search Bar methods
extension TodoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todos = todos?.filter { $0.name.contains(searchBar.text!)
        }
        tableView.reloadData()
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

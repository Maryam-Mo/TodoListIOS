//
//  TodoViewController.swift
//  TodoList
//
//  Created by Maryam on 4/28/20.
//  Copyright © 2020 Sofftech. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation

class TodoViewController: SwipeTableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var selectBtn: UIBarButtonItem!
    @IBOutlet weak var inProgressStatusBtn: UIBarButtonItem!
    @IBOutlet weak var completedStatusBtn: UIBarButtonItem!
    
    let realm = try! Realm()
    static let geoCoder = CLGeocoder()

    var location: String = ""
    let locationManager = CLLocationManager()
    var todos: [TodoDataModel]?
    var selectedTodo: TodoDataModel?
    var selectedTodos: [TodoDataModel]?
    var selectedCategory: CategoryDataModel? {
       didSet {
        reloadData()
       }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: Set up the location manager
        inProgressStatusBtn.title = ""
        completedStatusBtn.title = ""
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
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
                        todo.createdIn = self.location
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
                do {
                    try self.realm.write {
                        todo.status = Status.StatusEnum.IN_PROGRESS.rawValue
                    }
                } catch {
                    print("Error in saving new todo \(error)")
                }
            }
        }
        reloadData()
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
                do {
                    try self.realm.write {
                        todo.status = Status.StatusEnum.COMPLETED.rawValue
                    }
                } catch {
                    print("Error in saving new todo \(error)")
                }
            }
        }
        reloadData()
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
    
    //MARK: - Location Manager Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations[locations.count - 1] // Last location in this array is the most accurate one
        if lastLocation.horizontalAccuracy > 0 { // As soon as the result has high accuracy we will stop updating the location
            locationManager.stopUpdatingLocation()
        }
         let clLocation = CLLocation(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
        TodoViewController.geoCoder.reverseGeocodeLocation(clLocation) { placemarks, _ in
          if let place = placemarks?.first {
            let result = "\(place)".split(separator: "@")
            self.location = String(result[0])
          }
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let todo = todos?[indexPath.row] {
            cell.textLabel?.text = "\(todo.name)(\(todo.status))"
            cell.accessoryType = todo.status == Status.StatusEnum.COMPLETED.rawValue ? .checkmark : .disclosureIndicator
        } else {
           cell.textLabel?.text = "No Items Added Yet"
        }
        return cell
    }
    // MARK: - Tableview Delegate method
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

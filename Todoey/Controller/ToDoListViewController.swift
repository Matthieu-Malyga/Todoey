//
//  TodoListViewController.swift
//  Todoey
//
//  Created by malygam on 06/01/2019.
//  Copyright © 2019 Matthieu Malyga. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    lazy var realm: Realm = {
        return try! Realm()
    }()

    var todoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }

    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.showsCancelButton = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		loadData()
    }

    //MARK: - Helper methods

    private func loadData() {
		todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

    //MARK: - TableView DataSource methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
        	cell.textLabel?.text = item.title
        	cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }

    //MARK: - TableView Delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status : \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let item = todoItems?[indexPath.row] {
                do {
                    try realm.write {
						realm.delete(item)
                    }
                } catch {
                    print("Error deleting item : \(error)")
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

		var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item = Item()
                        item.title = textField.text!
                        currentCategory.items.append(item)
                    }
                } catch {
                    print("Error saving new items : \(error)")
                }
            }

            self.tableView.reloadData()

        }
        alert.addTextField() { alertTextField in
            alertTextField.placeholder = "Get some milk"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - SearchBar delegate methods

extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

		todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
		tableView.reloadData()

    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadData()
        searchBar.resignFirstResponder()
    }

}

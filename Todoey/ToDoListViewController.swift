//
//  TodoListViewController.swift
//  Todoey
//
//  Created by malygam on 06/01/2019.
//  Copyright © 2019 Matthieu Malyga. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

	var itemArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        for index in 1...20 {
            let item = Item()
            item.title = "Task \(index)"
            itemArray.append(item)
        }

//        if let itemArray = UserDefaults.standard.object(forKey: "itemArray") as? [Item] {
//            self.itemArray = itemArray
//        }
    }

    //MARK: - TableView DataSource methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }

    //MARK: - TableView Delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

		var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            let item = Item()
            item.title = textField.text!
			self.itemArray.append(item)
            //UserDefaults.standard.set(self.itemArray, forKey: "itemArray")
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


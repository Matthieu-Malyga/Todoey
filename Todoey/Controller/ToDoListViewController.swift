//
//  TodoListViewController.swift
//  Todoey
//
//  Created by malygam on 06/01/2019.
//  Copyright © 2019 Matthieu Malyga. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	var itemArray = [Item]()
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
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
		loadData()
    }

    //MARK: - Helper methods

    private func saveData() {
        try? context.save()
    }

    private func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), and predicate: NSPredicate? = nil) {

		let categoryPredicate = NSPredicate(format: "category.name MATCHES %@", selectedCategory!.name!)

        if let searchPredicate = predicate {
			request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, searchPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        if let fetchedItemArray = try? context.fetch(request) {
            itemArray = fetchedItemArray
            tableView.reloadData()
        }
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
        saveData()
        return cell
    }

    //MARK: - TableView Delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

		var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            let item = Item(context: self.context)
            item.title = textField.text!
            item.done = false
            item.category = self.selectedCategory!
			self.itemArray.append(item)
            self.saveData()
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
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@ ", searchBar.text!)
        loadData(with: request, and: searchPredicate)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadData()
        searchBar.resignFirstResponder()
    }

}

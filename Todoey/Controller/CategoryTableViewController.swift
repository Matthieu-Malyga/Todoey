//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by malygam on 07/01/2019.
//  Copyright © 2019 Matthieu Malyga. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
		loadData()
    }

    private func loadData(request: NSFetchRequest<Category> = Category.fetchRequest()) {
        if let fetchedCategoryArray = try? context.fetch(request) {
			categoryArray = fetchedCategoryArray
            tableView.reloadData()
        }
    }

    private func saveData() {
		try? context.save()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            let category = Category(context: self.context)
            category.name = textField.text
            self.categoryArray.append(category)
            self.saveData()
            self.tableView.reloadData()
        }
        alert.addTextField() { alertTextField in
            alertTextField.placeholder = "Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        // Configure the cell...
        if let categoryName = categoryArray[indexPath.row].name {
            cell.textLabel?.text = categoryName
        }

        return cell
    }

    //MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            context.delete(categoryArray[indexPath.row])
            categoryArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let selectedCategoryIndex = tableView.indexPathForSelectedRow?.row {
        	if segue.identifier == "GoToItems", let destinationViewController = segue.destination as? ToDoListViewController {
            	destinationViewController.selectedCategory = categoryArray[selectedCategoryIndex]
            }
        }

    }


}

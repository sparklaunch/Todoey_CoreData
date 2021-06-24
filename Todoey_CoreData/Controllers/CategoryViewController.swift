//
//  CategoryViewController.swift
//  Todoey_CoreData
//
//  Created by Jinwook Kim on 2021/06/24.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categories: [Category]? = [Category]()
    let appDelegate: AppDelegate = (UIApplication.shared.delegate) as! AppDelegate
    var context: NSManagedObjectContext {
        self.appDelegate.persistentContainer.viewContext
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField = UITextField()
        let alert: UIAlertController = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField: UITextField) in
            alertTextField.placeholder = "Enter a new category name"
            textField = alertTextField
        }
        let action: UIAlertAction = UIAlertAction(title: "Add a new category", style: .default) { (action: UIAlertAction) in
            let text: String = textField.text!
            self.addCategory(with: text)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Initialization

extension CategoryViewController {
    func initialize() {
        self.title = "Categories"
        self.fetchCategories()
    }
}

// MARK: - Creation

extension CategoryViewController {
    func addCategory(with text: String) {
        let newCategory: Category = Category(context: self.context)
        newCategory.name = text
        self.categories?.append(newCategory)
        do {
            try self.context.save()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch let error {
            let localizedError: String = error.localizedDescription
            print(localizedError)
        }
    }
}

// MARK: - Read

extension CategoryViewController {
    func fetchCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            self.categories = try self.context.fetch(request)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch let error {
            let localizedError: String = error.localizedDescription
            print(localizedError)
        }
    }
}

// MARK: - TableViewDataSource

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let category: Category = self.categories?[indexPath.row] {
            cell.textLabel?.text = category.name
        }
        else {
            cell.textLabel?.text = "No categories yet."
        }
        return cell
    }
}

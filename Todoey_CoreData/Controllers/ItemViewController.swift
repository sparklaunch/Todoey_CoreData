//
//  ItemViewController.swift
//  Todoey_CoreData
//
//  Created by Jinwook Kim on 2021/06/24.
//

import UIKit
import CoreData

class ItemViewController: UITableViewController {
    var items: [Item]? = [Item]()
    let appDelegate: AppDelegate = (UIApplication.shared.delegate) as! AppDelegate
    var context: NSManagedObjectContext {
        return self.appDelegate.persistentContainer.viewContext
    }
    var parentCategory: Category? {
        didSet {
            let parentCategoryName: String = self.parentCategory!.name!
            let predicate: NSPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", parentCategoryName)
            self.fetchItems(with: predicate)
            self.initialize(with: parentCategoryName)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField = UITextField()
        let alert: UIAlertController = UIAlertController(title: "Add a new item", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField: UITextField) in
            alertTextField.placeholder = "Enter a new item"
            textField = alertTextField
        }
        let action: UIAlertAction = UIAlertAction(title: "Add a new item", style: .default) { (action: UIAlertAction) in
            let text: String = textField.text!
            self.addItem(text)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Initialization

extension ItemViewController {
    func initialize(with title: String) {
        self.title = title
    }
}

// MARK: - UITableViewDataSource

extension ItemViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let item: Item = self.items?[indexPath.row] {
            cell.textLabel?.text = item.name
        }
        else {
            cell.textLabel?.text = "No items added yet."
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ItemViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - Create

extension ItemViewController {
    func addItem(_ text: String) {
        let newItem: Item = Item(context: self.context)
        newItem.name = text
        newItem.parentCategory = self.parentCategory!
        self.items?.append(newItem)
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

extension ItemViewController {
    func fetchItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            self.items = try self.context.fetch(request)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch let error {
            let localizedError: String = error.localizedDescription
            print(localizedError)
        }
    }
    func fetchItems(with predicate: NSPredicate) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = predicate
        do {
            self.items = try self.context.fetch(request)
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

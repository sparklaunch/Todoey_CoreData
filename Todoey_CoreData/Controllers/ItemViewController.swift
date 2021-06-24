//
//  ItemViewController.swift
//  Todoey_CoreData
//
//  Created by Jinwook Kim on 2021/06/24.
//

import UIKit
import CoreData

class ItemViewController: SwipeViewController {
    @IBOutlet var searchBar: UISearchBar!
    var items: [Item]? = [Item]()
    let appDelegate: AppDelegate = (UIApplication.shared.delegate) as! AppDelegate
    var context: NSManagedObjectContext {
        return self.appDelegate.persistentContainer.viewContext
    }
    var parentCategory: Category? {
        didSet {
            let parentCategoryName: String = self.parentCategory!.name!
            self.fetchItems()
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
        let cell: UITableViewCell = super.tableView(self.tableView, cellForRowAt: indexPath)
        if let item: Item = self.items?[indexPath.row] {
            cell.textLabel?.text = item.name
            cell.accessoryType = item.isChecked ? .checkmark : .none
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
        if let selectedItem: Item = self.items?[indexPath.row] {
            selectedItem.isChecked.toggle()
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
        let predicate: NSPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", self.parentCategory!.name!)
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

// MARK: - UISearchBarDelegate

extension ItemViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text: String = self.searchBar.text!
        let searchPredicate: NSPredicate = NSPredicate(format: "name CONTAINS[cd] %@", text)
        let categoryPredicate: NSPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", self.parentCategory!.name!)
        let compoundPredicate: NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate, categoryPredicate])
        self.fetchItems(with: compoundPredicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if self.searchBar.text!.count == 0 {
            self.searchBar.resignFirstResponder()
            self.fetchItems()
        }
    }
}

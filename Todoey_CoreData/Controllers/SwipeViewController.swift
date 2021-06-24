//
//  SwipeViewController.swift
//  Todoey_CoreData
//
//  Created by Jinwook Kim on 2021/06/24.
//

import UIKit
import SwipeCellKit

class SwipeViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.superInitialize()
    }
    func remove(at index: Int) {
        // Subclasses will do the task.
    }
}

// MARK: - UITableViewDataSource

extension SwipeViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right
        else {
            return nil
        }
        let deleteAction: SwipeAction = SwipeAction(style: .destructive, title: "Delete") { (swipeAction: SwipeAction, indexPath: IndexPath) in
            self.remove(at: indexPath.row)
        }
        deleteAction.image = UIImage(systemName: "trash")
        return [deleteAction]
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SwipeTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
}

// MARK: - Initialization

extension SwipeViewController {
    func superInitialize() {
        self.tableView.rowHeight = 80
    }
}

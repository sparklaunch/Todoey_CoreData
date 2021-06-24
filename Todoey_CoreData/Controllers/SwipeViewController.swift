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

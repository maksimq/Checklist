//
//  ViewController.swift
//  Checklist
//
//  Created by Максим on 16.02.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {

    private var items = [ChecklistItem]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        items.append(ChecklistItem(text: "Walk with dog"))
        items.append(ChecklistItem(text: "Brush my teeth", withCheckedOption: true))
        items.append(ChecklistItem(text: "Learn iOS development"))
        items.append(ChecklistItem(text: "Soccer practice", withCheckedOption: true))
        items.append(ChecklistItem(text: "Eat ice cream"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem", forIndexPath: indexPath)
        let item = items[indexPath.row]

        configureTextForCell(cell, withChecklistItem: item)
        configureCheckmarkForCell(cell, withChecklistItem: item)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let item = items[indexPath.row]
            item.toggleChecked()
            configureCheckmarkForCell(cell, withChecklistItem: item)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // This method automaticaly enable swipe-to-delete
    
        items.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
            // sender в данном случае это объект который вызвал данный переход. В нашем случае это 
            // одна из ячеек (cell) в которой была нажата кнопка 
            // зная кто вызвал это событие можно найти строку в таблице для заданной ячейки следующим образом:
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    private func configureTextForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.getText()
    }
    
    private func configureCheckmarkForCell(cell:UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.isChecked {
            label.text = "√"
        }else {
            label.text = ""
        }
        
    }
    
    private func appendItem(item: ChecklistItem){
        let newRowItem = items.count
        items.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowItem, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }
    
}

extension ChecklistViewController: ItemDetailViewControllerDelegate {
    func addItemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addItemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        appendItem(item)
        dismissViewControllerAnimated(true, completion: nil)
    }
    func addItemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        if let index = items.indexOf(item) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                configureTextForCell(cell, withChecklistItem: item)
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}

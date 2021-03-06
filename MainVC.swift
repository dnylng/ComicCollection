//
//  MainVC.swift
//  ComicCollection
//
//  Created by Danny Luong on 7/13/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var controller: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
//        generateTestData()

        attemptFetch()
    }

    // Cell behavior
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    // Secondary configure cell function
    func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
        
        // Update cell
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // If there are sections in the table
        if let sections = controller.sections {
            
            // Get the info out of the section and count them
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        // If there aren't any, then return 0
        return 0
    }
    
    // Height of a cell/row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    // User selected row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Make sure there are objs in our controller
        if let objs = controller.fetchedObjects, objs.count > 0 {
            
            // Perform a segue by passing the selected item
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    // Preps the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // If the segue is called ItemDetailsVC
        if segue.identifier == "ItemDetailsVC" {
            
            // Then set the destination as ItemDetailsVC
            if let destination = segue.destination as? ItemDetailsVC {
                
                // And set the itemToEdit var in ItemDetailsVC to the item being passed in segue
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            
            // Return the number of sections in the controller
            return sections.count
        }
        
        // If there aren't any, then return 0
        return 0
    }
    
    func attemptFetch() {
        
        // Fetch Item class
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        // Sort data that is being fetched based on timestamp
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        // Depending on the segment, sort it accordingly
        if segment.selectedSegmentIndex == 0 {
            fetchRequest.sortDescriptors = [dateSort]
        } else if segment.selectedSegmentIndex == 1 {
            fetchRequest.sortDescriptors = [priceSort]
        } else if segment.selectedSegmentIndex == 2 {
            fetchRequest.sortDescriptors = [titleSort]
        }
        
        // Instantiate fetch result controller
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Tells everyone to listen to this controller
        controller.delegate = self
        
        // Set the controller in the VC to this local controller
        self.controller = controller
        
        do {
            
            try controller.performFetch()
        } catch {
            
            let error = error as NSError
            print("\(error)")
        }
        
    }
    
    
    // When the segment value is changed
    @IBAction func segmentChanged(_ sender: Any) {
        
        // Attempt the fetch again so it can change the sort to the new segment index
        attemptFetch()
        tableView.reloadData()
    }
    
    // Whenever tableView is about to update, it'll listen for changes
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // When the controller did change, end the updates
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type) {
            
        case.insert:
            if let indexPath = newIndexPath {
                
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        case.delete:
            if let indexPath = indexPath {
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
            
        case.update:
            if let indexPath = indexPath {
                
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                
                // Update the cell data
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
            
        case.move:
            if let indexPath = indexPath {
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        }
    }
    
    // Test data
    func generateTestData() {
        
        let item = Item(context: context)
        item.title = "Detective Comics #027"
        item.price = 11000
        item.details = "This is the first appearance of the Dark Knight. Pretty cool huh?"
        
        let item2 = Item(context: context)
        item2.title = "Action Comics #001"
        item2.price = 10000
        item2.details = "Good ol' Man of Steel comin' in to save the day. Too bad kryptonite is is weakness."
        
        let item3 = Item(context: context)
        item3.title = "Teen Titans #001"
        item3.price = 8000
        item3.details = "Teeniest of all the Titans. George Perez run is lookin' real good!"
        
        ad.saveContext()
    }
    
}


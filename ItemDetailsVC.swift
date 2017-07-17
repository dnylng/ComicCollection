//
//  ItemDetailsVC.swift
//  ComicCollection
//
//  Created by Danny Luong on 7/14/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsFeild: CustomTextField!
    
    var stores = [Store]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Drop the title in the back bar button
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        // Generated stores already, saved in context
//        let store = Store(context: context)
//        store.name = "Best Buy"
//        
//        let store2 = Store(context: context)
//        store2.name = "Amazon"
//        
//        let store3 = Store(context: context)
//        store3.name = "Ebay"
//        
//        let store4 = Store(context: context)
//        store4.name = "NYC Comics"
//        
//        let store5 = Store(context: context)
//        store5.name = "Carolina Comics"
//        
//        let store6 = Store(context: context)
//        store6.name = "SDCC"
//        
//        ad.saveContext()
        
        fetchStores()
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let store = stores[row]
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    // Number of columns we'll have in the picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // Update the selected store when selected
    }
    
    // Generate a couple of stores for testing THIS FUNC DOESN'T WORK
    func generateTestStores() {
        
        let store = Store(context: context)
        store.name = "Best Buy"
        
        let store2 = Store(context: context)
        store2.name = "Amazon"
        
        let store3 = Store(context: context)
        store3.name = "Ebay"
        
        let store4 = Store(context: context)
        store4.name = "NYC Comics"
        
        let store5 = Store(context: context)
        store5.name = "Carolina Comics"
        
        let store6 = Store(context: context)
        store6.name = "San Diego Comic-Con"
        
        ad.saveContext()
        
    }
    
    // Gets the stores
    func fetchStores() {
        
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            
            // Handle error
        }
    }

    // Save info once user finishes entering in data
    @IBAction func saveItemPressed(_ sender: Any) {
        
        let item = Item(context: context)
        
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsFeild.text {
            item.details = details
        }
        
        // Set the store that is selected by the picker; component is column and we only have 1 column
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        
        navigationController?.popViewController(animated: true)
        
    }
    
}

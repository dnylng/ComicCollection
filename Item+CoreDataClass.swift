//
//  Item+CoreDataClass.swift
//  ComicCollection
//
//  Created by Danny Luong on 7/13/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import Foundation
import CoreData

public class Item: NSManagedObject {
    
    // Any time this item is inserted/created this func will be called
    public override func awakeFromInsert() {
        
        super.awakeFromInsert()
        
        // When created, assign the current date to the attribute "created"
        self.created = NSDate()
    }
    
}

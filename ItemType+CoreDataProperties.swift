//
//  ItemType+CoreDataProperties.swift
//  ComicCollection
//
//  Created by Danny Luong on 7/13/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}

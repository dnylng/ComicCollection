//
//  ItemCell.swift
//  ComicCollection
//
//  Created by Danny Luong on 7/13/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    
    func configureCell(item: Item) {
        
        title.text = item.title
        
        // Format the currency based on user's locale settings
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let formattedPrice = formatter.string(from: item.price as NSNumber) {
            price.text = "\(formattedPrice)"
        }
        
        details.text = item.details
        thumb.image = item.toImage?.image as? UIImage
    }

}

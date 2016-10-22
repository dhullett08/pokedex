//
//  movesCell.swift
//  Pokedex
//
//  Created by Dustin Hullett on 10/22/16.
//  Copyright © 2016 Dustin Hullett. All rights reserved.
//

import UIKit

class  movesCell: UITableViewCell {
    
    @IBOutlet weak var moveName: UILabel!
    
    func configureCell(name: String) {
        
        moveName.text = name
    }
    
}

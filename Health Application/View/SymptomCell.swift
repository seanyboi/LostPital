//
//  SymptomCell.swift
//  Health Application
//
//  Created by Sean O'Connor on 10/04/2018.
//  Copyright © 2018 Sean O'Connor. All rights reserved.
//

import UIKit

class SymptomCell: UITableViewCell {

    @IBOutlet weak var symptomName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // Format text appropriately, in case it takes up multiple lines
    func updateUI(symptomNames: Symptoms) {
        symptomName.font = UIFont(name:"Avenir", size:18)
        symptomName.text = symptomNames.name
        symptomName.numberOfLines = 0;
        symptomName.lineBreakMode = .byWordWrapping
    }

}

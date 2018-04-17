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
        // Initialization code
    }

    
    func updateUI(symptomNames: Symptoms) {

        symptomName.text = symptomNames.symptomName

    }

}

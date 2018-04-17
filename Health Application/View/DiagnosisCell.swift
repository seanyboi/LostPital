//
//  DiagnosisCell.swift
//  Health Application
//
//  Created by Sean O'Connor on 17/04/2018.
//  Copyright © 2018 Sean O'Connor. All rights reserved.
//

import UIKit

class DiagnosisCell: UITableViewCell {

    @IBOutlet weak var suggestedDiagnosisLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    
    
    }
    
    
    func updateUI(diagnosis: Diagnosis) {
        
        suggestedDiagnosisLabel.text = diagnosis.diagnosisName
        
    }


}

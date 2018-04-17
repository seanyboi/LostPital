//
//  Diagnosis.swift
//  Health Application
//
//  Created by Sean O'Connor on 17/04/2018.
//  Copyright © 2018 Sean O'Connor. All rights reserved.
//

import Foundation

class Diagnosis {
    
    private var _diagnosisName: String?
    
    var diagnosisName: String {
        return _diagnosisName!
    }

    
    init(diagnosisName: String?) {
        
        _diagnosisName = diagnosisName
        
    }
    
    
}

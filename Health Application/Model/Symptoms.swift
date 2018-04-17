//
//  Symptoms.swift
//  Health Application
//
//  Created by Sean O'Connor on 12/04/2018.
//  Copyright © 2018 Sean O'Connor. All rights reserved.
//

import Foundation

class Symptoms {
    
    private var _symptomName: String?
    private var _id: Int?


    var symptomName: String {
        return _symptomName!
    }
    
    var id: Int {
        return _id!
    }

    init(symptomName: String?, id: Int?) {
        
        _symptomName = symptomName
        _id = id
 
    }
    
    
}

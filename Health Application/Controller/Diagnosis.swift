//
//  Diagnosis.swift
//  Health Application
//
//  Created by Sean O'Connor on 10/04/2018.
//  Copyright © 2018 Sean O'Connor. All rights reserved.
//

import UIKit

class Diagnosis: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func forwardTest(_ sender: Any) {
        
        performSegue(withIdentifier: "4-5", sender: nil)
        
    }
    
}

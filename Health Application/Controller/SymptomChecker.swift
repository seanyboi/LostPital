//
//  ViewController.swift
//  Health Application
//
//  Created by Sean O'Connor on 10/04/2018.
//  Copyright © 2018 Sean O'Connor. All rights reserved.
//

import UIKit

class SymptomChecker: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func searchButton(_ sender: Any) {
        
        performSegue(withIdentifier: "1-2", sender: nil)
        
    }
    

}


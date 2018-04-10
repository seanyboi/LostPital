//
//  ViewController.swift
//  Health Application
//
//  Created by Sean O'Connor on 10/04/2018.
//  Copyright © 2018 Sean O'Connor. All rights reserved.
//

import UIKit

class SymptomChecker: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var symptomCheckerTable: UITableView!
    
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var yearOfBirthTextField: UITextField!
    
    var symptomName = ["X", "Y", "Z", "1", "2", "3"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Must set delegates.
        symptomCheckerTable.delegate = self
        symptomCheckerTable.dataSource = self
        
    }
    
    //Places array data into tableview.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = symptomCheckerTable.dequeueReusableCell(withIdentifier: "SymptomName", for: indexPath) as? SymptomCell{
            
            let symptomName = self.symptomName[indexPath.row]
            
            cell.symptomName.text = symptomName
            
            return cell
            
        } else {
            
            return UITableViewCell()
        }
        
        
    }
    
    //Determines how many rows tableview will have.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return symptomName.count
        
        
    }

    //Allows navigation to next controller.

    @IBAction func searchButton(_ sender: Any) {
        
        performSegue(withIdentifier: "1-2", sender: nil)
        
    }
    

}


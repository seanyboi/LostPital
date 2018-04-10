//
//  FurtherQuestions.swift
//  Health Application
//
//  Created by Sean O'Connor on 10/04/2018.
//  Copyright © 2018 Sean O'Connor. All rights reserved.
//

import UIKit

class SearchingSymptoms: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var searchingSymptomsTableView: UITableView!
    
    var searchingArray = ["X", "Y", "Z", "1", "2", "3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchingSymptomsTableView.delegate = self
        searchingSymptomsTableView.dataSource = self
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchingArray.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if let cell = searchingSymptomsTableView.dequeueReusableCell(withIdentifier: "ExtraSymptoms", for: indexPath) as? ExtraSymptomCell {
            
            let searchingArray = self.searchingArray[indexPath.row]
            
            cell.symptomNameLabel.text = searchingArray
            
            return cell
            
        } else {
            
            return UITableViewCell()
        }
        
        
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
}

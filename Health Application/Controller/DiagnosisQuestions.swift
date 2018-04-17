//
//  Diagnosis.swift
//  Health Application
//
//  Created by Sean O'Connor on 10/04/2018.
//  Copyright © 2018 Sean O'Connor. All rights reserved.
//

import UIKit

class DiagnosisQuestions: UIViewController {
    
    @IBOutlet weak var Q1Lbl: UILabel!
    
    @IBOutlet weak var Q1Stack: UIStackView!
    
    @IBOutlet weak var Q2Lbl: UILabel!
    
    @IBOutlet weak var Q2Stack: UIStackView!
    
    @IBOutlet weak var Q3Lbl: UILabel!
    
    @IBOutlet weak var Q3Stack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
    }
    
    
    @IBAction func questionChecker(sender: UIButton) {
        
        let titleName = sender.currentTitle!
        
        if titleName == "Yes" {
            
            if Q2Stack.isHidden && Q2Lbl.isHidden == true {
                
                Q2Lbl.isHidden = false
                Q2Stack.isHidden = false
                
            } else if Q3Lbl.isHidden && Q3Stack.isHidden == true {
                
                Q3Lbl.isHidden = false
                Q3Stack.isHidden = false
                
            }
            
            
        } else if titleName == "No" {
            
            if Q2Stack.isHidden && Q2Lbl.isHidden == true {
                
                Q2Lbl.isHidden = false
                Q2Stack.isHidden = false
                
            } else if Q3Lbl.isHidden && Q3Stack.isHidden == true {
                
                Q3Lbl.isHidden = false
                Q3Stack.isHidden = false
                
            }
            
            
        } else if titleName == "Don't Know" {
            
            if Q2Stack.isHidden && Q2Lbl.isHidden == true {
                
                Q2Lbl.isHidden = false
                Q2Stack.isHidden = false
                
            } else if Q3Lbl.isHidden && Q3Stack.isHidden == true {
                
                Q3Lbl.isHidden = false
                Q3Stack.isHidden = false
                
            }
        }
    }
    
    
    @IBAction func movingControllers(sender: UIButton) {
        
        performSegue(withIdentifier: "4-5", sender: nil)
        
    }
    
    

    
}

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
    
    var symptoms: Symptoms!
    
    var suggestedSymptomsArray = [Symptoms]()
    
    var selectedSymptoms = [Symptoms]()
    
    var clicked = [String]()

    var addedSymptom = ""
    
    var sex = ""
    var age = 0
    var radius = 0
    
    var evidence = [[String:Any]]()
    var evidenceIDs = [String]()        // TODO pass this through later (should be added to on previous view, e.g. abdominal pane id)
    var extras: [String:Any] = ["disable_groups": true]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(selectedSymptoms)
        print(sex)
        print(age)
        print(radius)
        
        
    }
    
    
    func callingApi() {
        
        
        evidenceIDs.append("s_247")
        for evidenceID in evidenceIDs {
            evidence.append(["id": (evidenceID), "choice_id": "present", "initial": true])
        }
        //var evidence = [["id": "s_47", "choice_id": "present", "initial": true]]
        let json: [String:Any] = ["sex": sex,
                                  "age": self.age,
                                  "evidence": self.evidence,
                                  //"extras": extras
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let url = URL(string: "https://api.infermedica.com/v2/diagnosis")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("f93580b1", forHTTPHeaderField: "App-Id")
        request.setValue("e2d0f821e118e1bd3fa21290d5bc7e22", forHTTPHeaderField: "App-Key")
        //request.setValue("true", forHTTPHeaderField: "Dev-Mode")
        
        request.httpBody = jsonData
        
        getQuestions(request: request) {data in
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                print(responseJSON)
                
                //let question = try JSONDecoder().decode(Diagnosis.Question.self, from: data!)
                let diag = try JSONDecoder().decode(Diagnosis.self, from: data!)
                //print(ques.question.text)
                //print(ques.question.items.first!.id)
                //print(ques.question.items.first!)
                
                //var symptom: Symptoms
                //print(ques.question.items.first!.name)
                let symptom = Symptoms()
                symptom.name = diag.question.items.first!.name
                symptom.id = diag.question.items.first!.id
                print(symptom.name)
                print(symptom.id)
                self.suggestedSymptomsArray.append(symptom)
                self.updateTableViewWithSymptoms(symptoms: self.suggestedSymptomsArray)
                //print(ques.question.items.first!.name)
                //print(ques.question.items.name)
                
            } catch let error as NSError {
                print(error)
            }
        }
        
        
    }
    
    func getQuestions (request: URLRequest, completion:@escaping (Data?) -> Void) {
        
        _ = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                print(error?.localizedDescription ?? "No data")
                
                return completion(nil)
            }
            
            return completion(data)
            
            }.resume()
    }
    
    func updateTableViewWithSymptoms(symptoms: [Symptoms]) {
        
        DispatchQueue.main.async {
            
            //self.additionalSymptomsTableView.reloadData()
            //self.activityIndicator.stopAnimating()
            
        }
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

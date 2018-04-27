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
    
    var selectedSymptoms = [Symptoms]() // Symptoms up to this point
    
    var clicked = [String]()

    var addedSymptom = ""
    
    var question = ""
    var questionCounter = 1
    
    // Selections passed through from previous Controller
    var sex = ""
    var age = 0
    var radius = 0
    
    var evidence = [[String:Any]]()
    var diag : Diagnosis!
    var extras = ["disable_groups": true]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add all symptoms to evidence array
        for symptom in selectedSymptoms {
            evidence.append(["id": (symptom.id), "choice_id": "present", "initial": true])
        }
        callingApi()
        
    }
    
        // Function for setting up GET request for diagnosis from Infermedica
    func callingApi() {
        
        let json: [String:Any] = ["sex": String(sex),
                                  "age": age,
                                  "evidence": evidence,
                                  "extras": extras
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
                _ = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                self.diag = try JSONDecoder().decode(Diagnosis.self, from: data!)

                let symptom = Symptoms()
                symptom.name = self.diag.question.items.first!.name
                symptom.id = self.diag.question.items.first!.id
                self.question = self.diag.question.text
                self.suggestedSymptomsArray.append(symptom)
                self.updateQuestion()
                
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    // Updates the state of the Controller once the asynchronous API call has been completed
    func updateQuestion() {
        DispatchQueue.main.async {
            if self.questionCounter == 1 {
                self.Q1Lbl.font = UIFont(name:"Avenir", size:18)
                self.Q1Lbl.text = "\n\(self.question)"
                self.Q1Lbl.numberOfLines = 0;
                self.Q1Lbl.lineBreakMode = .byWordWrapping
            } else if self.questionCounter == 2 {
                self.Q2Lbl.font = UIFont(name:"Avenir", size:18)
                self.Q2Lbl.text = self.question
                self.Q2Lbl.numberOfLines = 0;
                self.Q2Lbl.lineBreakMode = .byWordWrapping
            } else if self.questionCounter == 3 {
                self.Q3Lbl.font = UIFont(name:"Avenir", size:18)
                self.Q3Lbl.text = self.question
                self.Q3Lbl.numberOfLines = 0;
                self.Q3Lbl.lineBreakMode = .byWordWrapping
            }
        }
    }
    
    // Send the request to the URL, uses a completionHandler to ensure we obtain
    // data, and handle cases where the URL does not respond
    func getQuestions (request: URLRequest, completion:@escaping (Data?) -> Void) {
        
        _ = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                print(error?.localizedDescription ?? "No data")
                
                return completion(nil)
            }
            
            return completion(data)
            
            }.resume()
    }
    
    // Updates counters and labels to be visible in the correct order.
    // Also updates evidence array for the next GET request
    @IBAction func questionChecker(sender: UIButton) {
        let titleName = sender.currentTitle!
        
        if titleName == "Yes" {
            if Q2Stack.isHidden && Q2Lbl.isHidden == true {
                self.evidence.append(["id": (suggestedSymptomsArray.last!.id), "choice_id": "present", "initial": false])
                questionCounter = 2
                callingApi()
                Q2Lbl.isHidden = false
                Q2Stack.isHidden = false
                
            } else if Q3Lbl.isHidden && Q3Stack.isHidden == true {
                self.evidence.append(["id": (suggestedSymptomsArray.last!.id), "choice_id": "present", "initial": false])
                questionCounter = 3
                callingApi()
                Q3Lbl.isHidden = false
                Q3Stack.isHidden = false
                
            }
            
            
        } else if titleName == "No" {
            
            if Q2Stack.isHidden && Q2Lbl.isHidden == true {
                self.evidence.append(["id": (suggestedSymptomsArray.last!.id), "choice_id": "absent", "initial": false])
                questionCounter = 2
                callingApi()
                Q2Lbl.isHidden = false
                Q2Stack.isHidden = false
                
            } else if Q3Lbl.isHidden && Q3Stack.isHidden == true {
                self.evidence.append(["id": (suggestedSymptomsArray.last!.id), "choice_id": "absent", "initial": false])
                questionCounter = 3
                callingApi()
                Q3Lbl.isHidden = false
                Q3Stack.isHidden = false
                
            }
            
            
        } else if titleName == "Don't Know" {
            
            if Q2Stack.isHidden && Q2Lbl.isHidden == true {
                self.evidence.append(["id": (suggestedSymptomsArray.last!.id), "choice_id": "unknown", "initial": false])
                questionCounter = 2
                callingApi()
                Q2Lbl.isHidden = false
                Q2Stack.isHidden = false
                
            } else if Q3Lbl.isHidden && Q3Stack.isHidden == true {
                self.evidence.append(["id": (suggestedSymptomsArray.last!.id), "choice_id": "unknown", "initial": false])
                questionCounter = 3
                callingApi()
                Q3Lbl.isHidden = false
                Q3Stack.isHidden = false
            }
        }
    }
    
    // Passes through necessary variables to next Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? PotentialDiagnosis {
            destination.finalDiagnosis = diag
            destination.radius = radius
        }
        
    }
    
    @IBAction func movingControllers(sender: UIButton) {
        
        performSegue(withIdentifier: "4-5", sender: nil)
        
    }
    
    

    
}

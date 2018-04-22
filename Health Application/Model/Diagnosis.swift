//
//  Diagnosis.swift
//  Health Application
//
//  Created by Sean O'Connor on 17/04/2018.
//  Copyright © 2018 Sean O'Connor. All rights reserved.
//

import Foundation

class Diagnosis : Decodable {
    
    /*init() {
        //self.question = question
    }*/
    
    var conditions = [Condition]()
    
    class Condition : Decodable {
        var common_name : String!
        var id : String!
        var name : String!
        var probability : Decimal!
    }
    
    var question: Question!
    
    class Question : Decodable {
        // let type : String
        var items: [Item]!
        
        class Item : Decodable {
            var choices : [Choice]!
            var id : String!
            var name : String!
            
            class Choice : Decodable {
                
                var id : String!
                var label : String!
            }
        }
        
        var text : String!
    }
    var should_stop: Int!
}

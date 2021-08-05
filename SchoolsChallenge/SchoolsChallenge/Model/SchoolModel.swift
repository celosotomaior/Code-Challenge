//
//  SchoolModel.swift
//  SchoolsChallenge
//
//  Created by Marcelo Sotomaior on 16/07/2021.
//

import Foundation

class School {
    var dbn : String?
    var schoolName : String?
    var phoneNumber : String?
    var address: String?
    var overviewParagraph : String?
    var website :String?
    var graduationRate: String?
    var finalGrades: String?
    var latitude: String?
    var longitude: String?
    var city: String?
    var state: String?
    var zip: String?
    
    var satScore: ScoreOnSAT?
    
   
    init(dictionary : [String : Any]){
        
        self.dbn = dictionary["dbn"] as? String
        self.schoolName = dictionary["school_name"] as? String
        self.overviewParagraph  = dictionary["overview_paragraph"] as? String
        self.phoneNumber = dictionary["phone_number"] as? String
        self.address = dictionary["primary_address_line_1"] as? String
        self.website = dictionary["website"] as? String
        self.graduationRate = dictionary["graduation_rate"] as? String
        self.finalGrades = dictionary["finalgrades"] as? String
        self.longitude = dictionary["longitude"] as? String
        self.latitude = dictionary["latitude"] as? String
        self.city = dictionary["city"] as? String
        self.state = dictionary["state_code"] as? String
        self.zip = dictionary["zip"] as? String
      
        
    }
    
  
    class func Schools(dictionaries: [[String: Any]]) -> [School] {
        
        var arraySchool : [School] = []
        for dict in dictionaries {
            let aSchool = School(dictionary: dict)
            arraySchool.append(aSchool)
        }
        
        return arraySchool
       
    }
}

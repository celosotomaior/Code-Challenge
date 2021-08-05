//
//  ShowSchoolDetail.swift
//  SchoolsChallenge
//
//  Created by Marcelo Sotomaior on 16/07/2021.
//

import Foundation


class ScoreOnSAT {
    
    var dbn :String?
    var numOfSatTestTakers : String?
    var satCriticalReadingAvgScore : String?
    var satMathAvgScore : String?
    var satWritingAvgScore : String?
    var schoolName : String?
    
    
    init(dictionary:[String:Any]) {
        
        self.dbn = dictionary["dbn"] as? String
        self.numOfSatTestTakers = dictionary["num_of_sat_test_takers"] as? String
        self.satCriticalReadingAvgScore = dictionary["sat_critical_reading_avg_score"] as? String
        self.satMathAvgScore  = dictionary["sat_math_avg_score"] as? String
        self.satWritingAvgScore = dictionary["sat_writing_avg_score"] as? String
        self.schoolName = dictionary["school_name"] as? String
    
    }
    
     
    init(dbn:String ,numOfSatTestTakers:String? ,satCriticalReadingAvgScore:String,satMathAvgScore:String?,satWritingAvgScore:String?,schoolName:String?){
        
        self.dbn = dbn
        self.numOfSatTestTakers = numOfSatTestTakers
        self.satCriticalReadingAvgScore = satCriticalReadingAvgScore
        self.satMathAvgScore  = satMathAvgScore
        self.satWritingAvgScore = satWritingAvgScore
        self.schoolName = schoolName
        
    }
    
    

    class func  SATScores(dictionaries: [[String: Any]]) -> [ScoreOnSAT] {
        
        var SATScoreArray : [ScoreOnSAT] = []
        for dict in dictionaries {
            let a_school = ScoreOnSAT(dictionary: dict)
            SATScoreArray.append(a_school)
        }
        
        return SATScoreArray
        
    }
    
    
}

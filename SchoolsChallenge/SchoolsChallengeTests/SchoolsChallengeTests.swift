//
//  SchoolsChallengeTests.swift
//  SchoolsChallengeTests
//
//  Created by Marcelo Sotomaior on 16/07/2021.
//

import XCTest
@testable import SchoolsChallenge

class SchoolsChallengeTests: XCTestCase {

    func testInitializeSingleton() {
        let service = Networking.sharedInstance
        
        XCTAssertNotNil(service)
    }
    
//    func testLoadSchoolDataWithBadUrl() {
    func testLoadTheSchools() {
        Networking.sharedInstance.getData(completionHandler: { (schools:[School]?,error:Error?) in
            
            if let theFirstSchool = schools?.first {
                XCTAssertNotNil(theFirstSchool)
            }
            
        })
           
    }
    
    
    func testLoadSATData() {
         Networking.sharedInstance.getScoreData(completion: { (scores:[ScoreOnSAT]?,error:Error?) in
            
            if let theFirstSchool = scores?.first {
                XCTAssertNotNil(theFirstSchool)
            }
            
        })
    }
    
    
    func testLoadSATScores() {
         Networking.sharedInstance.getScoreData(completion: { (scores:[ScoreOnSAT]?,error:Error?) in
            var dbn = ""
            
            print("num1")
            scores?.forEach({ sat in
                dbn = sat.dbn!
            })
            
                XCTAssertNotNil(dbn)
            
            
        })
    }
    
    
    func testLoadedeScoresDataWithValidUrl() {
        
        
        Networking().getScoreData { (scores:[ScoreOnSAT]?,error:Error?) in
           
            var numOfScores = 0
           
            if let scores = scores {
                numOfScores = scores.count
                print(numOfScores,"num")
            }
           
            
    }
       
    }
}

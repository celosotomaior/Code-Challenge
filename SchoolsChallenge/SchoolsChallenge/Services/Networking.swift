//
//  Networking.swift
//  SchoolsChallenge
//
//  Created by Marcelo Sotomaior on 16/07/2021.
//

import Foundation

class Networking {
    
    static let sharedInstance: Networking = {
           let instance = Networking()
           // setup code
           return instance
       }()

public func getData( completionHandler: @escaping ( [School]?, Error?)->()) {
    
    guard let url = URL(string: "https://data.cityofnewyork.us/resource/97mf-9njv.json") else { print("Bad URL"); return }
    
    
    let task = URLSession.shared
    let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10 )
    
    task.dataTask(with: urlRequest, completionHandler: { (data,response,error) in
        
        guard error == nil else { return completionHandler(nil,error) }
    
        if let data = data {
           
            let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]
           
            let schools = School.Schools(dictionaries: dataDictionary)
            
            completionHandler(schools, nil )
        }
              
            
        
    }).resume()
    
}
    
    /**
     *Return an array of SATdata  from the network request
     * @param: completion- school
     * @param: completion- Error
     */
    func getScoreData( completion : @escaping ([ScoreOnSAT]?,Error? )->()){
        
        let url = URL(string: "https://data.cityofnewyork.us/resource/734v-jeq5.json")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        let task = URLSession.shared.dataTask(with: request) {(data,response,error) in
            
            if let data = data {
            let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]
            let SATScores = ScoreOnSAT.SATScores(dictionaries: dataDictionary)
            completion(SATScores, nil )
            
        }else {
            
            completion(nil, error)
        }
        
    }
    task.resume()
        
  }

}

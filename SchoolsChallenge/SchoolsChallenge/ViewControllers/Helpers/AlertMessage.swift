//
//  AlertMessage.swift
//  SchoolsChallenge
//
//  Created by Marcelo Sotomaior on 17/07/2021.
//

import UIKit

struct AlertMessage {
    static func error(for message: String) -> UIAlertController {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        let alert = UIAlertController(title: "Error âšī¸", message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        
        return alert
    }
    
    static func success(for message: String) -> UIAlertController {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        let alert = UIAlertController(title: "Success đ", message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        
        return alert
    }
    
}

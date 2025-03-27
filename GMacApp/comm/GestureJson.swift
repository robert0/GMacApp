//
//  GestureJson.swift
//  GMacApp
//
//  Created by Robert Talianu
//

import Foundation


public class GestureJson: Codable {
    
    var gestureKey: String
    var gestureCorrelationFactor: Double
    var gestureCommand: String
    
    init(gestureKey: String, gestureCorrelationFactor: Double, gestureCommand: String) {
        self.gestureKey = gestureKey
        self.gestureCorrelationFactor = gestureCorrelationFactor
        self.gestureCommand = gestureCommand
    }
    
    
}

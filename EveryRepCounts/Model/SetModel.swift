//
//  SetModel.swift
//  EveryRepCounts
//
//  Created by Shiv Wadwani on 11/15/23.
//

import Foundation
import SwiftData

@Model
class SetModel {
    var number: Int
    var reps: Int
    var weight: Float
    var timestamp: Date
    
    init(number: Int, reps: Int = 0, weight: Float = 0.0, timestamp: Date) {
        self.number = number
        self.reps = reps
        self.weight = weight
        self.timestamp = timestamp
    }
}

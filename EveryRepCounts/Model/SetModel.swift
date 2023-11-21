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
    
    init(number: Int, reps: Int = 0, weight: Float = 0.0) {
        self.number = number
        self.reps = reps
        self.weight = weight
    }
}

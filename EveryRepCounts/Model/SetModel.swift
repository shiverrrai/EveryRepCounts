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
    var workoutNumber: Int
    var exerciseNumber: Int
    var number: Int
    var reps: Int
    var weight: Float
    var timestamp: Date
    var exercise: ExerciseModel?
    
    init(workoutNumber: Int, exerciseNumber: Int, number: Int, reps: Int = 0, weight: Float = 0.0, timestamp: Date) {
        self.workoutNumber = workoutNumber
        self.exerciseNumber = exerciseNumber
        self.number = number
        self.reps = reps
        self.weight = weight
        self.timestamp = timestamp
    }
}

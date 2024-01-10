//
//  ExerciseModel.swift
//  EveryRepCounts
//
//  Created by Shiv Wadwani on 11/15/23.
//

import Foundation
import SwiftData

@Model
class ExerciseModel {
    var workoutNumber: Int
    var number: Int
    var name: String
    var category: String
    var notes: String
    var timestamp: Date
    @Relationship(deleteRule: .cascade) var sets = [SetModel]()
    var workout: WorkoutModel?
    
    init(workoutNumber: Int, number: Int = 0, name: String = "", category: String = "", notes: String = "", timestamp: Date) {
        self.workoutNumber = workoutNumber
        self.number = number
        self.name = name
        self.category = category
        self.notes = notes
        self.timestamp = timestamp
    }
}

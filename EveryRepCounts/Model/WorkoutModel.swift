//
//  WorkoutModel.swift
//  EveryRepCounts
//
//  Created by Shiv Wadwani on 11/15/23.
//

import Foundation
import SwiftData

@Model
class WorkoutModel {
    @Attribute(.unique) var id: UUID
    var number: Int
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \ExerciseModel.workout) var exercises = [ExerciseModel]()
    
    init(id: UUID, number: Int, name: String = "") {
        self.id = id
        self.number = number
        self.name = name
    }
}

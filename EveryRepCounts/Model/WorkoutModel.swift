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
    var name: String
    @Relationship(deleteRule: .cascade) var exercises = [ExerciseModel]()
    
    init(name: String = "") {
        self.name = name
    }
}

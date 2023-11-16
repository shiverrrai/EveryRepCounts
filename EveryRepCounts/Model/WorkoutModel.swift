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
    @Attribute(.unique) var id: Int
    var name: String
    @Relationship(deleteRule: .cascade) var exercises = [ExerciseModel]()
    
    init(id: Int, name: String = "") {
        self.id = id
        self.name = name
    }
}

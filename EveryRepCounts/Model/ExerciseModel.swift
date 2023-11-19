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
    var name: String
    var category: String
    var notes: String
    @Relationship(deleteRule: .cascade) var sets = [SetModel]()
    
    init(name: String = "", category: String = "", notes: String = "") {
        self.name = name
        self.category = category
        self.notes = notes
    }
}

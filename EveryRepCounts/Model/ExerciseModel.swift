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
    var number: Int
    var name: String
    var category: String
    var notes: String
    var timestamp: Date
    @Relationship(deleteRule: .cascade) var sets = [SetModel]()
    
    init(number: Int = 0, name: String = "", category: String = "", notes: String = "", timestamp: Date) {
        self.number = number
        self.name = name
        self.category = category
        self.notes = notes
        self.timestamp = timestamp
    }
}

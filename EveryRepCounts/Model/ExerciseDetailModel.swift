//
//  ExerciseDetailModel.swift
//  EveryRepCounts
//
//  Created by Shiv Wadwani on 2/13/24.
//

import Foundation
import SwiftData

@Model
class ExerciseDetailModel: Codable {
    enum CodingKeys: CodingKey {
        case name
        case number
        case details
    }
    
    var name: String
    var number: Int
    var details: String?
    
    
    init(name: String, number: Int, details: String = "") {
        self.name = name
        self.number = number
        self.details = details
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.number = try container.decode(Int.self, forKey: .number)
        self.details = try container.decode(String.self, forKey: .details)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(number, forKey: .number)
        try container.encode(details, forKey: .details)
    }
}

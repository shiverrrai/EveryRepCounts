/*

Abstract:
A representation of a user's workout data.
*/

import Foundation
import SwiftUI

struct Workout: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    
    var exercises: Exercise
    struct Exercise: Hashable, Codable, Identifiable {
        var id: Int
        var name: String
        var category: String
        var description: String
        
        var sets: SetData
        struct SetData: Hashable, Codable, Identifiable {
            var id: Int
            var number: Int
            var reps: Int
            var weight: Float
            var timestamp: Date // UNIX format, eg. 1531294146340
        }
    }
}

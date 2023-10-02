//
//  SetView.swift
//  EveryRepCounts
//
//  Created by Shiv Wadwani on 10/2/23.
//

import SwiftUI

struct SetRow: Identifiable, Equatable {
    var id: Int
    var exerciseName: String
    var numReps: Int
    var weight: Double
    init() {
        self.id = 0
        self.exerciseName = ""
        self.numReps = 0
        self.weight = 0.0
    }
    init(id: Int, exerciseName: String, numReps: Int, weight: Double) {
        self.id = id
        self.exerciseName = exerciseName
        self.numReps = numReps
        self.weight = weight
    }
}

struct SetView: View {
    var set: Workout.Exercise.SetData
    var body: some View {
        HStack(){
            Text(String(set.number+1)).frame(maxWidth: .infinity).background(Color.teal).border(Color.black)
            Text(String(set.weight)).frame(maxWidth: .infinity).background(Color.cyan).border(Color.black)
            Text(String(set.reps)).frame(maxWidth: .infinity).background(Color.mint).border(Color.black)
        }
        
        
    }
}


struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        SetView(set: ModelData().workouts[0].exercises[0].sets[0])
    }
}

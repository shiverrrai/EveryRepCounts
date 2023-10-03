//
//  ExerciseView.swift
//  EveryRepCounts
//
//  Created by Shiv Wadwani on 10/2/23.
//

import SwiftUI

struct ExerciseView: View {
    var exercise: Workout.Exercise
    var body: some View {
        Grid{
            Text(exercise.name).font(.title)
            GridRow{
                Text("Set").font(.headline)
                Text("Weight (lbs)").font(.headline)
                Text("Reps").font(.headline)
            }
            ForEach(exercise.sets){setRow in
                SetView(set: setRow)
            }
        }
        
    }
}

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseView(exercise: ModelData().workouts[0].exercises[0])
    }
}

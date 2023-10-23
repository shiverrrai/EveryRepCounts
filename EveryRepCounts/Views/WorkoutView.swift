//
//  WorkoutView.swift
//  EveryRepCounts
//
//  Created by Shiv Wadwani on 10/23/23.
//

import SwiftUI

struct WorkoutView: View {
    var workout: Workout
    
    var body: some View {
        VStack {
            Text(workout.name).font(.title)
            ScrollView() {
                VStack{
                    ForEach(workout.exercises) { exerciseRow in
                        ExerciseView(exercise: exerciseRow)
                    }.padding()
                }.padding()
            }
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(workout: ModelData().workouts[0])
    }
}

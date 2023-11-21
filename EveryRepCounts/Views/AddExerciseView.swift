//
//  AddExerciseView.swift
//  EveryRepCounts
//
//  Created by Shiv Wadwani on 11/18/23.
//

import SwiftUI
import SwiftData

// TODO: update to populate exercise data
struct AddExerciseView: View {
    @Bindable var workout: WorkoutModel
    
    var body: some View {
        Button("Add Exercise", action: addExercise)
    }
    
    func addExercise() {
        let exercise = ExerciseModel()
        let set = SetModel(number: 0, reps: 0, weight: 0.0)
        workout.exercises.append(exercise)
        workout.exercises.last?.sets.append(set)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: WorkoutModel.self, configurations: config)
        var example = WorkoutModel(name: "Example Workout")
        return AddExerciseView(workout: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}

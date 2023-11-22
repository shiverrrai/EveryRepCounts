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
    @State private var selectedExercise = "Bench Press"
    let exercisesList = ["Bench Press", "Lat Pulldown", "Lateral Raises", "Squat"]
    
    var body: some View {
        Form {
            Picker("Exercise", selection: $selectedExercise) {
                ForEach(exercisesList, id: \.self) { exercise in
                    Text(exercise)
                }
            }
        }
        Button("Add Exercise", action: addExercise)
    }
    
    func addExercise() {
        let exercise = ExerciseModel(name: $selectedExercise.wrappedValue, timestamp: Date.now)
        let set = SetModel(number: 0, reps: 0, weight: 0.0)
        exercise.sets.append(set)
        workout.exercises.append(exercise)
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

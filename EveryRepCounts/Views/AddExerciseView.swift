//
//  AddExerciseView.swift
//  EveryRepCounts
//
//  Created by Shiv Wadwani on 11/18/23.
//

import SwiftUI
import SwiftData

// TODO: improve exercise selection view below
struct AddExerciseView: View {
    @Bindable var workout: WorkoutModel
    @State private var searchText = ""
    let exerciseList = ["Bench Press", "Lat Pulldown", "Lateral Raises", "Squat"]
    
    var body: some View {
        List {
            ForEach(exerciseList, id: \.self) { exercise in
                HStack {
                    Text(exercise)
                    Spacer()
                    Button("Add Exercise", systemImage: "plus.square.fill", action: {addExercise(exerciseName: exercise)}).labelStyle(.iconOnly)
                }
            }
        }
    }
    
    func addExercise(exerciseName: String) {
        let exercise = ExerciseModel(name: exerciseName, timestamp: Date.now)
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

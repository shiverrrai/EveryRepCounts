//
//  AddExerciseView.swift
//  EveryRepCounts
//
//  Created by Shiv Wadwani on 11/18/23.
//

import SwiftUI
import SwiftData

struct AddExerciseView: View {
    @Bindable var workout: WorkoutModel
    @State private var searchText = ""
    let exerciseList = ["Bench Press", "Lat Pulldown", "Lateral Raises", "Squat"]
    
    var body: some View {
        List {
            HStack {
                Label("Icon", systemImage: "magnifyingglass").labelStyle(.iconOnly)
                TextField("Search for an exercise", text: $searchText)
            }
            Section(header: Text("Exercises")) {
                ForEach(searchResults, id: \.self) { exercise in
                    HStack {
                        Text(exercise)
                        Spacer()
                        Button("Add Exercise", systemImage: "plus.square.fill", action: {addExercise(exerciseName: exercise)}).labelStyle(.iconOnly)
                    }
                }
            }
            
        }
    }
    
    func addExercise(exerciseName: String) {
        let exercise = ExerciseModel(number: 0, name: exerciseName, timestamp: Date.now)
        if let lastExercise = workout.exercises.max(by: {$0.number < $1.number}) {
            exercise.number = lastExercise.number+1
        }
        workout.exercises.append(exercise)
    }
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return exerciseList
        } else {
            return exerciseList.filter { $0.contains(searchText) }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: WorkoutModel.self, configurations: config)
        let example = WorkoutModel(name: "Example Workout")
        return AddExerciseView(workout: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}

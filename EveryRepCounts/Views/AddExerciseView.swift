//
//  AddExerciseView.swift
//  EveryRepCounts
//
//  Created by Shiv Wadwani on 11/18/23.
//

import SwiftUI
import SwiftData

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(5)
            .background(configuration.isPressed ? Color.white : Color.blue)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .animation(.easeOut(duration: 0.5), value: configuration.isPressed)
    }
}

struct ExerciseRow: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var workout: WorkoutModel
    var exerciseName: String

    var body: some View {
        HStack {
            Text(exerciseName)
            Spacer()
            NavigationLink(destination: ExerciseDetailView()) {}
            Button("Add Exercise", systemImage: "plus.square.fill") {
                addExercise(exerciseName: exerciseName)
            }
            .labelStyle(.iconOnly)
            .buttonStyle(CustomButtonStyle())
        }
    }
    
    func addExercise(exerciseName: String) {
        let exercise = ExerciseModel(workoutNumber: workout.number, number: 0, name: exerciseName, timestamp: Date.now)
        if let lastExercise = workout.exercises.max(by: {$0.number < $1.number}) {
            exercise.number = lastExercise.number+1
        }
        let set = SetModel(workoutNumber: exercise.workoutNumber, exerciseNumber: exercise.number, number: 0, reps: 0, weight: 0.0, timestamp: Date.now)
        workout.exercises.append(exercise)
        exercise.workout = workout
        exercise.sets.append(set)
        modelContext.insert(exercise)
        modelContext.insert(set)
    }
}

struct AddExerciseView: View {
    @Environment(\.modelContext) var modelContext
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
                    ExerciseRow(workout: workout, exerciseName: exercise)
                }
            }
            
        }
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
        let example = WorkoutModel(id: UUID(), number: 0, name: "Example Workout")
        return AddExerciseView(workout: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}

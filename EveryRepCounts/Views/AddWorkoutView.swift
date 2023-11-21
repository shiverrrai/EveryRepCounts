//
//  WorkoutModelView.swift
//  EveryRepCounts
//
//  Created by Shiv Wadwani on 11/18/23.
//

import SwiftUI
import SwiftData

struct AddWorkoutView: View {
    @Bindable var workout: WorkoutModel
    
    var body: some View {
        TextField("Workout Name", text: $workout.name).font(.title).padding(.horizontal)
        Form {
            ForEach($workout.exercises) { exercise in
                // TODO: fix bug for incorrect exercise/set data population
                // Reference: https://developer.apple.com/documentation/swiftui/table
                Grid {
                    GridRow {
                        Text("Set Number")
                        Spacer()
                        Text("Weight (lbs)")
                        Spacer()
                        Text("Reps")
                    }
                    ForEach(exercise.sets) { setData in
                        GridRow {
                            Text("\(setData.number.wrappedValue + 1)")
                            Spacer()
                            Text("\(setData.weight.wrappedValue)")
                            Spacer()
                            Text("\(setData.reps.wrappedValue)")
                        }
                    }
                }
            }
            NavigationLink("Add Exercise") {
                AddExerciseView(workout: workout)
            }
        }
    }
    
    

}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: WorkoutModel.self, configurations: config)
        var example = WorkoutModel(name: "Example Workout")
//        example.exercises.append(ExerciseModel(id: 1))
        return AddWorkoutView(workout: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}

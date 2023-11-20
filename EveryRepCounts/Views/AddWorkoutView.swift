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
                Table(exercise.sets) {
                    TableColumn("Set Number") { data in
                        Text("\(data.number.wrappedValue)")
                    }
                    TableColumn("Weight (lbs)") { data in
                        Text("\(data.weight.wrappedValue)")
                    }
                    TableColumn("Reps") { data in
                        Text("\(data.reps.wrappedValue)")
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

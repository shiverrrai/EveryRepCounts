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
        List {
            ForEach($workout.exercises.sorted(by: {$0.timestamp.wrappedValue < $1.timestamp.wrappedValue})) { exercise in
                Section(header: Text(exercise.name.wrappedValue)) {
                    Grid {
                        GridRow {
                            Text("Set").bold()
                            Spacer()
                            Text("Weight (lbs)").bold()
                            Spacer()
                            Text("Reps").bold()
                        }
                        // TODO: allow user to populate set data and add new sets
                        ForEach(exercise.sets.sorted(by: {$0.timestamp.wrappedValue < $1.timestamp.wrappedValue})) { setData in
                            GridRow {
                                Text("\(setData.number.wrappedValue + 1)")
                                Spacer()
                                Text("\(setData.weight.wrappedValue)")
                                Spacer()
                                Text("\(setData.reps.wrappedValue)")
                            }
                        }
                    }
                    Button("Add Set", action: {addSet(exercise: exercise)})
                }
            }
            NavigationLink("Add Exercise") {
                AddExerciseView(workout: workout)
            }
        }
    }
    
    func addSet(exercise: Binding<ExerciseModel>) {
        let setNumber = exercise.sets.count
        let set = SetModel(number: setNumber, reps: 0, weight: 0.0, timestamp: Date.now)
        exercise.wrappedValue.sets.append(set)
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

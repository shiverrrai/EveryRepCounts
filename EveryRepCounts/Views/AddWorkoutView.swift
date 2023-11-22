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
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
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
                        ForEach(exercise.sets.sorted(by: {$0.timestamp.wrappedValue < $1.timestamp.wrappedValue})) { setData in
                            GridRow {
                                Text("\(setData.number.wrappedValue + 1)")
                                Spacer()
                                TextField("0.0", value: setData.weight, formatter: formatter).keyboardType(.numberPad).fixedSize()
                                Spacer()
                                TextField("0", value: setData.reps, formatter: formatter).keyboardType(.numberPad).fixedSize()
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
    
    // TODO: incorrect aliases form between sets
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
        let example = WorkoutModel(name: "Example Workout")
//        example.exercises.append(ExerciseModel(id: 1))
        return AddWorkoutView(workout: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}

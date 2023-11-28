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
            let sortedExercises = Array(workout.exercises).sorted(by: {$0.number < $1.number})
            ForEach(sortedExercises) { exercise in
                Section(header: Text(exercise.name)) {
                    Grid {
                        GridRow {
                            Text("Set").bold()
                            Spacer()
                            Text("Weight (lbs)").bold()
                            Spacer()
                            Text("Reps").bold()
                        }
                        let sortedSets = Array(exercise.sets).sorted(by: {$0.number < $1.number})
                        ForEach(sortedSets.indices, id: \.self) { index in
                            let setData = sortedSets[index]
                            GridRow {
                                Text("\(setData.number + 1)")
                                Spacer()
                                TextField("0.0", value: Binding(get: { setData.weight }, set: { newValue in sortedSets[index].weight = newValue }), formatter: formatter).keyboardType(.numberPad).fixedSize()
                                Spacer()
                                TextField("0", value: Binding(get: { setData.reps }, set: { newValue in sortedSets[index].reps = newValue }), formatter: formatter).keyboardType(.numberPad).fixedSize()
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
    func addSet(exercise: ExerciseModel) {
        let setId = exercise.sets.count
        let set = SetModel(number: setId, reps: 0, weight: 0.0, timestamp: Date.now)
        exercise.sets.append(set)
    }
    
    

}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: WorkoutModel.self, configurations: config)
        let example = WorkoutModel(name: "Example Workout")
        return AddWorkoutView(workout: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}

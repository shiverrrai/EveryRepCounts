//
//  WorkoutModelView.swift
//  EveryRepCounts
//
//  Created by Shiv Wadwani on 11/18/23.
//

import SwiftUI
import SwiftData

struct DisplaySets: View {
    var sets: [SetModel]
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        ForEach(sets.indices, id: \.self) { index in
            let setData = sets[index]
            GridRow {
                Text("\(setData.number + 1)")
                Spacer()
                TextField("0.0", value: Binding(get: { setData.weight }, set: { newValue in sets[index].weight = newValue }), formatter: formatter).keyboardType(.numberPad).fixedSize()
                Spacer()
                TextField("0", value: Binding(get: { setData.reps }, set: { newValue in sets[index].reps = newValue }), formatter: formatter).keyboardType(.numberPad).fixedSize()
            }
        }
    }
}

struct DisplayExercises: View {
    @Environment(\.modelContext) var modelContext
    var exercise: ExerciseModel
    
    var body: some View {
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
                DisplaySets(sets: sortedSets)
                Button("Add Set", action: {addSet(exercise: exercise)})
            }
        }
    }
    
    func addSet(exercise: ExerciseModel) {
        let setId = exercise.sets.count
        let set = SetModel(number: setId, reps: 0, weight: 0.0, timestamp: Date.now)
        exercise.sets.append(set)
    }
    
    
}

struct AddWorkoutView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var workout: WorkoutModel
    @State private var sortedExercises: [ExerciseModel] = []
    
    var body: some View {
        TextField("Workout Name", text: $workout.name).font(.title).padding(.horizontal)
        List {
            ForEach(sortedExercises) { exercise in
                DisplayExercises(exercise: exercise)
            }.onDelete { indices in
                deleteExercises(at: indices)
            }
            NavigationLink("Add Exercise") {
                AddExerciseView(workout: workout)
            }
        }.onAppear {
            sortedExercises = Array(workout.exercises).sorted(by: {$0.number < $1.number})
        }.toolbar {
            EditButton()
        }
    }
    
    //TODO: fix exercise numbering when deleting an exercise
    func deleteExercises(at indices: IndexSet) {
        for i in indices {
            sortedExercises.remove(at: i)
            // now remove workout.exercises by number instead of index
            if let index = workout.exercises.firstIndex(where: {$0.number == i}) {
                let exercise = workout.exercises[index]
                workout.exercises.remove(at: index)
                modelContext.delete(exercise)
                
            }
        }
        
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

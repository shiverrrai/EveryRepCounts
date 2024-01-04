//
//  WorkoutModelView.swift
//  EveryRepCounts
//
//  Created by Shiv Wadwani on 11/18/23.
//

import SwiftUI
import SwiftData
import Combine

// https://www.wwdcnotes.com/notes/wwdc23/10187/
// https://www.wwdcnotes.com/notes/wwdc23/10154/
// Need to fully understand SwiftData and Observation

public struct SelectAllTextOnBeginEditingModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(
                for: UITextField.textDidBeginEditingNotification)) { _ in
                    DispatchQueue.main.async {
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.selectAll(_:)), to: nil, from: nil, for: nil
                        )
                    }
                }
        }
}

extension View {
    public func selectAllTextOnBeginEditing() -> some View {
        modifier(SelectAllTextOnBeginEditingModifier())
    }
}

struct DisplaySets: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var workout: WorkoutModel
    var exerciseNumber: Int
    @Binding var sets: [SetModel]
    
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
                TextField("0.0", value: Binding(get: { setData.weight }, set: { newValue in sets[index].weight = newValue }), formatter: formatter)
                    .selectAllTextOnBeginEditing()
                    .keyboardType(.decimalPad)
                    .fixedSize()
                Spacer()
                TextField("0", value: Binding(get: { setData.reps }, set: { newValue in sets[index].reps = newValue }), formatter: formatter)
                    .selectAllTextOnBeginEditing()
                    .keyboardType(.numberPad)
                    .fixedSize()
//                    .swipeActions(edge: .leading) {
//                        Button(role: .destructive) {
//                            deleteSet(at: index)
//                        } label: {
//                            Label("Delete", systemImage: "trash")
//                        }
//                    }
                Spacer()
                // perhaps create a separate view for a set row? that way the button will delete that particular set only. you can also try using the swipe actions for this
                Button {
                    deleteSet(at: index)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }
    
    func deleteSet(at index: Int) {
        print(index)
//        do {
////            for index in indices {
//                print(index)
//                let removedSet = sets.remove(at: index)
//                if let exerciseIndex = workout.exercises.firstIndex(where: {$0.number == exerciseNumber}) {
//                    if let setIndex = workout.exercises[exerciseIndex].sets.firstIndex(where: {$0.number == removedSet.number}) {
//                        let set = workout.exercises[exerciseIndex].sets[setIndex]
//                        modelContext.delete(set)
//                        workout.exercises[exerciseIndex].sets.remove(at: setIndex)
//                    }
//                }
////            }
//            try modelContext.save()
//        } catch {
//            // Handle exception
//        }
        
    }
}

struct DisplayExercise: View {
    @Bindable var workout: WorkoutModel
    var exercise: ExerciseModel
    @State private var sortedSets: [SetModel] = []
    
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
                DisplaySets(workout: workout, exerciseNumber: exercise.number, sets: $sortedSets)
            }
            Button("Add Set", action: {addSet(exercise: exercise)}).deleteDisabled(true)
        }.onAppear {
            sortedSets = Array(exercise.sets).sorted(by: {$0.number < $1.number})
        }.onChange(of: exercise) {
            sortedSets = Array(exercise.sets).sorted(by: {$0.number < $1.number})
        }
    }
    
    func addSet(exercise: ExerciseModel) {
        let setId = exercise.sets.count
        let set = SetModel(number: setId, reps: 0, weight: 0.0, timestamp: Date.now)
        exercise.sets.append(set)
        sortedSets = Array(exercise.sets).sorted(by: {$0.number < $1.number})
    }
    
    
}

struct AddWorkoutView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var workout: WorkoutModel
    @State private var sortedExercises: [ExerciseModel] = []
    
    var body: some View {
        TextField("Workout Name", text: $workout.name).font(.title).padding(.horizontal)
        List {
            ForEach(sortedExercises.indices, id: \.self) { index in
                DisplayExercise(workout: workout, exercise: sortedExercises[index])
            }.onDelete { indices in
                deleteExercises(at: indices)
            }
            NavigationLink("Add Exercise") {
                AddExerciseView(workout: workout)
            }
        }.onAppear {
            sortedExercises = Array(workout.exercises).sorted(by: {$0.number < $1.number})
        }
    }
    
    func deleteExercises(at indices: IndexSet) {
        do {
            for i in indices {
                let removedExercise = sortedExercises.remove(at: i)
                // now remove workout.exercises by number instead of index
                if let index = workout.exercises.firstIndex(where: {$0.number == removedExercise.number}) {
                    let exercise = workout.exercises[index]
                    modelContext.delete(exercise)
                    workout.exercises.remove(at: index)
                }
            }
            try modelContext.save()
        } catch {
            // Handle exception
        }
        
    }

}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: WorkoutModel.self, configurations: config)
        let example = WorkoutModel(id: UUID(), number: 0, name: "Example Workout")
        return AddWorkoutView(workout: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}

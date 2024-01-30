//
//  WorkoutModelView.swift
//  EveryRepCounts
//
//  Created by Shiv Wadwani on 11/18/23.
//

import SwiftUI
import SwiftData
import Combine

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

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

struct DisplaySet: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var singleSet: SetModel
    var number: Int
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        HStack(alignment: .center) {
            Text("\(number + 1)")
                .frame(width: 100, height: 30, alignment: .leading)
            Spacer()
            TextField("Weight", value: $singleSet.weight, formatter: formatter)
                .selectAllTextOnBeginEditing()
                .keyboardType(.decimalPad)
                .fixedSize()
                .frame(width: 100, height: 30, alignment: .center)
            Spacer()
            TextField("Reps", value: $singleSet.reps, formatter: formatter)
                .selectAllTextOnBeginEditing()
                .keyboardType(.numberPad)
                .fixedSize()
                .frame(width: 100, height: 30, alignment: .trailing)
        }
    }
}

struct DisplayExercise: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var exercise: ExerciseModel
    @Query var sets: [SetModel]
    
    var body: some View {
        HStack {
            Text("Set").bold()
            Spacer()
            Text("Weight (lbs)").bold()
            Spacer()
            Text("Reps").bold()
        }
        ForEach(sets.indices, id: \.self) { index in
            DisplaySet(singleSet: sets[index], number: index)
        }.onDelete { indices in
            deleteSets(at: indices)
        }
        Button("Add Set", action: {addSet(exercise: exercise)}).deleteDisabled(true)
    }
    
    init(exercise: ExerciseModel, workoutNumber: Int, exerciseNumber: Int) {
        _exercise = Bindable(exercise)
        _sets = Query(filter: #Predicate<SetModel> { set in
            set.workoutNumber == workoutNumber && set.exerciseNumber == exerciseNumber
        }, sort: [SortDescriptor(\SetModel.number)])
    }
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    func addSet(exercise: ExerciseModel) {
        let set = SetModel(workoutNumber: exercise.workoutNumber, exerciseNumber: exercise.number, number: 0, reps: 0, weight: 0.0, timestamp: Date.now)
        if let lastSet = sets.max(by: {$0.number < $1.number}) {
            set.number = lastSet.number+1
        }
        exercise.sets.append(set)
        modelContext.insert(set)
    }
    
    func deleteSets(at indices: IndexSet) {
        do {
            for i in indices {
                let set = sets[i]
                modelContext.delete(set)
            }
            try modelContext.save()
        } catch {
            // Handle exception
        }
    }
}

struct AddWorkoutView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var workout: WorkoutModel
    @Query private var exercises: [ExerciseModel]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(exercises) { exercise in
                    Section {
                        HStack {
                            Text(exercise.name)
                                .bold()
                            Spacer()
                            Button(action: {deleteExercise(exercise: exercise)}) {
                                Label("", systemImage: "trash")
                                    .labelStyle(.iconOnly)
                            }.buttonStyle(BorderlessButtonStyle())
                        }
                        DisplayExercise(exercise: exercise, workoutNumber: exercise.workoutNumber, exerciseNumber: exercise.number)
                    }
                }
                NavigationLink("Add Exercise") {
                    AddExerciseView(workout: workout)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Done") {
                        hideKeyboard()
                    }
                }
            }
        }.navigationTitle($workout.name)
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    init(workout: WorkoutModel, number: Int) {
        _workout = Bindable(workout)
        _exercises = Query(filter: #Predicate<ExerciseModel> { exercise in
            exercise.workoutNumber == number
        }, sort: [SortDescriptor(\ExerciseModel.number)])
    }
    
    func deleteExercise(exercise: ExerciseModel) {
        do {
            for set in exercise.sets {
                modelContext.delete(set)
            }
            modelContext.delete(exercise)
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
        return AddWorkoutView(workout: example, number: example.number)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}

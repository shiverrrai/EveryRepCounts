//
//  WorkoutModelView.swift
//  EveryRepCounts
//
//  Created by Shiv Wadwani on 11/18/23.
//

import SwiftUI
import SwiftData
import Combine

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

// TODO: fix set deletion
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
        GridRow {
            Text("\(singleSet.number + 1)")
            Spacer()
            TextField("0.0", value: $singleSet.weight, formatter: formatter)
                .selectAllTextOnBeginEditing()
                .keyboardType(.decimalPad)
                .fixedSize()
            Spacer()
            TextField("0", value: $singleSet.reps, formatter: formatter)
                .selectAllTextOnBeginEditing()
                .keyboardType(.numberPad)
                .fixedSize()
        }
    }
}

struct DisplayExercise: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var exercise: ExerciseModel
    @Query var sets: [SetModel]
    
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
                ForEach(sets.indices, id: \.self) { index in
                    DisplaySet(singleSet: sets[index], number: sets[index].number)
                }
            }
            Button("Add Set", action: {addSet(exercise: exercise)}).deleteDisabled(true)
        }
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
}

struct AddWorkoutView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var workout: WorkoutModel
    @Query private var exercises: [ExerciseModel]
    
    var body: some View {
        TextField("Workout Name", text: $workout.name).font(.title).padding(.horizontal)
        List {
            ForEach(exercises) { exercise in
                DisplayExercise(exercise: exercise, workoutNumber: exercise.workoutNumber, exerciseNumber: exercise.number)
            }.onDelete { indices in
                deleteExercises(at: indices)
            }
            NavigationLink("Add Exercise") {
                AddExerciseView(workout: workout)
            }
        }
    }
    
    init(workout: WorkoutModel, number: Int) {
        _workout = Bindable(workout)
        _exercises = Query(filter: #Predicate<ExerciseModel> { exercise in
            exercise.workoutNumber == number
        }, sort: [SortDescriptor(\ExerciseModel.number)])
    }
    
    func deleteExercises(at indices: IndexSet) {
        do {
            for i in indices {
                let exercise = exercises[i]
                modelContext.delete(exercise)
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
        return AddWorkoutView(workout: example, number: example.number)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}

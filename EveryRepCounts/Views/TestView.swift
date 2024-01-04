//
//  TestView.swift
//  EveryRepCounts
//
//  Created by Shiv Wadwani on 12/31/23.
//

import SwiftUI
import SwiftData

struct TestView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var workout: WorkoutModel
    @Query private var exercises: [ExerciseModel]
    
    var body: some View {
        TextField("Workout Name", text: $workout.name).font(.title).padding(.horizontal)
        List {
            ForEach(exercises) { exercise in
                Text(exercise.name + " " + String(exercise.number))
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
//                workout.exercises.remove(at: i)
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
        return TestView(workout: example, number: example.number)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}

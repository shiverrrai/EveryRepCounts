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
        return TestView(workout: example, number: example.number)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}

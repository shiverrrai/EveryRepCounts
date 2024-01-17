//
//  ContentView.swift
//  EveryRepCounts
//
//  Created by Shiv Wadwani on 9/11/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\WorkoutModel.number)]) var workouts: [WorkoutModel]
    @Query(sort: [SortDescriptor(\ExerciseModel.number)]) var exercises: [ExerciseModel]
    @State private var path = [WorkoutModel]()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(workouts) { workout in
                    NavigationLink(value: workout) {
                        VStack(alignment: .leading) {
                            Text(workout.name)
                                .font(.headline)
                        }
                    }
                }.onDelete(perform: deleteWorkouts)
            }
            .navigationTitle("Every Rep Counts")
            .navigationDestination(for: WorkoutModel.self) { workout in
                AddWorkoutView(workout: workout, number: workout.number)
            }
            .toolbar {
                Button("Add Workout", action: addWorkout)
                Button("Print Workout Data", action: printWorkoutData)
            }
        }
    }
    
    func addWorkout() {
        let workout = WorkoutModel(id: UUID(), number: 0)
        if let lastWorkout = workouts.max(by: {$0.number < $1.number}) {
            workout.number = lastWorkout.number+1
        }
        modelContext.insert(workout)
        path = [workout]
    }
    
    // for debugging only
    func printWorkoutData() {
        print("Workouts: \(workouts)")
        for workout in workouts {
            print("~~~Workout \(workout.number) Exercises (workout.exercises):")
            for exercise in workout.exercises {
                print("\(exercise.name) \(exercise.number)")
            }
        }
        print("~~~exercises")
        for exercise in exercises {
            print("\(exercise.name) \(exercise.number)")
        }
    }
    
    
    func deleteWorkouts(_ indexSet: IndexSet) {
        do {
            for index in indexSet {
                let workout = workouts[index]
                // SwiftData bug: https://developer.apple.com/forums/thread/740649
                // Cascade delete not working
                for exercise in workout.exercises {
                    modelContext.delete(exercise)
                }
                modelContext.delete(workout)
            }
            try modelContext.save()
        }
        catch {
            // Handle exception
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

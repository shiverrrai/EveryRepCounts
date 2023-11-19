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
    @Query var workouts: [WorkoutModel]
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
            .navigationDestination(for: WorkoutModel.self, destination: AddWorkoutView.init)
            .toolbar {
                Button("Add Workout", action: addWorkout)
            }
        }
    }
    
    func addWorkout() {
        let workout = WorkoutModel()
        modelContext.insert(workout)
        path = [workout]
    }
    
    
    func deleteWorkouts(_ indexSet: IndexSet) {
        for index in indexSet {
            let workout = workouts[index]
            modelContext.delete(workout)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

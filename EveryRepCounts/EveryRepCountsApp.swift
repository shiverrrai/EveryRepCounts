//
//  EveryRepCountsApp.swift
//  EveryRepCounts
//
//  Created by Shiv Wadwani on 9/11/23.
//

import SwiftData
import SwiftUI

@main
struct EveryRepCountsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: [WorkoutModel.self, ExerciseDetailModel.self]) { result in
            do {
                let container = try result.get()

                // Check we haven't already added our users.
                let descriptor = FetchDescriptor<ExerciseDetailModel>()
                let existingExercises = try container.mainContext.fetchCount(descriptor)
                guard existingExercises == 0 else { return }

                // Load and decode the JSON.
                guard let url = Bundle.main.url(forResource: "exerciseDetailData", withExtension: "json") else {
                    fatalError("Failed to find exerciseDetailData.json")
                }

                let data = try Data(contentsOf: url)
                let exercises = try JSONDecoder().decode([ExerciseDetailModel].self, from: data)

                // Add all our data to the context.
                for exercise in exercises {
                    container.mainContext.insert(exercise)
                }
            } catch {
                print("Failed to pre-seed database.")
            }

        }
    }
}

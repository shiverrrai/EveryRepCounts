//
//  ExerciseDetailView.swift
//  EveryRepCounts
//
//  Created by Shiv Wadwani on 2/11/24.
//

import SwiftUI
import SwiftData

struct ExerciseDetailView: View {
    var exerciseName: String
    @Query private var exercise: [ExerciseDetailModel]
    
    init(exerciseName: String) {
        self.exerciseName = exerciseName
        var descriptor = FetchDescriptor<ExerciseDetailModel>(
            predicate: #Predicate {$0.name == exerciseName}
        )
        descriptor.fetchLimit = 1
        self._exercise = Query(descriptor)
    }
    
    
        
    var body: some View {
        // Implement your detailed exercise view here
        VStack {
            Text(exercise[0].name).font(.title)
                .padding()
            if let exerciseDetails = exercise[0].details {
                Text(exerciseDetails).font(.subheadline)
            }
        }
        
    }
}

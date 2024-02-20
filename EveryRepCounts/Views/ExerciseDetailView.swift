//
//  ExerciseDetailView.swift
//  EveryRepCounts
//
//  Created by Shiv Wadwani on 2/11/24.
//

import SwiftUI

struct ExerciseDetailView: View {
    var exerciseName: String
    
    var body: some View {
        // Implement your detailed exercise view here
        Text(exerciseName).font(.title)
            .padding()
    }
}

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
        }.modelContainer(for: WorkoutModel.self)
    }
}

//
//  EveryRepCountsApp.swift
//  EveryRepCounts
//
//  Created by Shiv Wadwani on 9/11/23.
//

import SwiftUI

@main
struct EveryRepCountsApp: App {
    @StateObject private var modelData = ModelData()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(modelData)
        }
    }
}

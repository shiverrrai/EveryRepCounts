//
//  ContentView.swift
//  EveryRepCounts
//
//  Created by Shiv Wadwani on 9/11/23.
//

import SwiftUI


struct ContentView: View {
    @State private var username: String = ""
    @State private var inputSet = SetRow()
    @State private var numberFormatter: NumberFormatter = {
        var nf = NumberFormatter()
        nf.numberStyle = .decimal
        return nf
    }()
    
    let sets = [
        SetRow(id: 0, exerciseName: "Bench Press", numReps: 12, weight: 115),
        SetRow(id: 1, exerciseName: "Bench Press", numReps: 12, weight: 115),
        SetRow(id: 2, exerciseName: "Lat Pulldown", numReps: 10, weight: 130)
    ]
    
    var body: some View {
        List {
            Grid {
                GridRow {
                    Text("Set")
                    Text("Exercise")
                    Text("Reps")
                    Text("Weight")
                }
                .bold()
                Divider()
                ForEach(sets) { setItem in
                    GridRow {
                        Text(setItem.id+1, format: .number)
                        Text(setItem.exerciseName)
                        Text(setItem.numReps, format: .number)
                        Text(setItem.weight, format: .number)
                    }
                    if setItem != sets.last {
                        Divider()
                    }
                }
                Divider()
                
                GridRow {
                    TextField("Set", value: $inputSet.id, formatter: numberFormatter)
                    TextField("Exercise", text: $inputSet.exerciseName)
                    TextField("Reps", value: $inputSet.numReps, formatter: numberFormatter)
                    TextField("Weight", value: $inputSet.weight, formatter: numberFormatter)
                }
            }
//            .padding()
        }
//        print(String(inputSet.id))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

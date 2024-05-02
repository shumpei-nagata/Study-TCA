//
//  Study_TCAApp.swift
//  Study-TCA
//
//  Created by Shumpei Nagata on 2024/05/02.
//

import SwiftUI

@main
struct Study_TCAApp: App {
    var body: some Scene {
        WindowGroup {
            CounterView(store: .init(initialState: .init()) {
                CounterFeature()
            })
        }
    }
}

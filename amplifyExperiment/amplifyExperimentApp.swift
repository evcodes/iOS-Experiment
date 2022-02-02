//
//  amplifyExperimentApp.swift
//  amplifyExperiment
//
//  Created by Varela, Eddy on 1/28/22.
//

import SwiftUI

@main
struct amplifyExperimentApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    // add a default initializer and configure Amplify
    init() {
        configureAmplify()
    }
}

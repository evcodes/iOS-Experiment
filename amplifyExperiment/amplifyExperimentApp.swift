//
//  amplifyExperimentApp.swift
//  amplifyExperiment
//
//  Created by Varela, Eddy on 1/28/22.
//

import SwiftUI
import AWSDataStorePlugin
import Amplify
import AWSAPIPlugin

@main
struct amplifyExperimentApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    func configureAmplify() {
        let models = AmplifyModels()
        let apiPlugin = AWSAPIPlugin(modelRegistration: models)
        let dataStorePlugin = AWSDataStorePlugin(modelRegistration: models)
        do {
            try Amplify.add(plugin: apiPlugin)
            try Amplify.add(plugin: dataStorePlugin)
            try Amplify.configure()
            print("Initialized Amplify");
        } catch {
            assert(false, "Could not initialize Amplify: \(error)")
        }
        
    }

    // add a default initializer and configure Amplify
    init() {
        configureAmplify()
    }
}

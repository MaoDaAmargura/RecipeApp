//
//  SavrApp.swift
//  Savr
//
//  Created by Austin Kelley on 3/9/25.
//

import SwiftUI

@main
struct SavrApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        
        UIRefreshControl.appearance().tintColor = .orange
    }
}

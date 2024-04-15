//
//  DiaryApp.swift
//  Diary
//
//  Created by Simmons on 4/15/24.
//

import SwiftUI

@main
struct DiaryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

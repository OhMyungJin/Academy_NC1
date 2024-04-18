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
            NavigationView {
                CalendarView()
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .accentColor(.hex5E3D25)
            .onAppear {
                // UIKit을 사용하여 뒤로가기 버튼 텍스트 숨기기
                let appearance = UINavigationBarAppearance()
                appearance.titleTextAttributes = [.foregroundColor: UIColor(Color.hex5E3D25)]
                
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}

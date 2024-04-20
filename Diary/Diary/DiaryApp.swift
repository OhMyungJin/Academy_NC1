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
                // 네비게이션 바 외관 설정
                let appearance = UINavigationBarAppearance()
                appearance.titleTextAttributes = [.foregroundColor: UIColor(Color.hex5E3D25)]
                
                UINavigationBar.appearance().standardAppearance = appearance // 모든 인스턴스의 표준 외관 설정
                UINavigationBar.appearance().scrollEdgeAppearance = appearance // 스크롤 엣지 설정
            }
        }
    }
}

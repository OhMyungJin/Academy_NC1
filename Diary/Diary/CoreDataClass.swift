//
//  CoreDataClass.swift
//  Diary
//
//  Created by Simmons on 4/17/24.
//
import CoreData
import SwiftUI

class CoreDataClass: ObservableObject {
    @Published var diary: [DiaryDate] = []
    @Published var money: [Money] = []
    @Published var feels: [Emotions] = []

    private var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext, dateFormat: String) {
        self.viewContext = context
        loadDiaryData(dateFormat: dateFormat)
        loadMoneyData(dateFormat: dateFormat)
        loadFeelsData(dateFormat: dateFormat)
    }

    func loadDiaryData(dateFormat: String) {
        let request: NSFetchRequest<DiaryDate> = DiaryDate.fetchRequest()
        request.predicate = NSPredicate(format: "dateString == %@", dateFormat)
        do {
            diary = try viewContext.fetch(request)
        } catch {
            print("Error fetching DiaryDate: \(error.localizedDescription)")
        }
    }

    func loadMoneyData(dateFormat: String) {
        let request: NSFetchRequest<Money> = Money.fetchRequest()
        request.predicate = NSPredicate(format: "dateString == %@", dateFormat)
        do {
            money = try viewContext.fetch(request)
        } catch {
            print("Error fetching Money: \(error.localizedDescription)")
        }
    }

    func loadFeelsData(dateFormat: String) {
        let request: NSFetchRequest<Emotions> = Emotions.fetchRequest()
        request.predicate = NSPredicate(format: "dateString == %@", dateFormat)
        do {
            feels = try viewContext.fetch(request)
        } catch {
            print("Error fetching Emotions: \(error.localizedDescription)")
        }
    }
}

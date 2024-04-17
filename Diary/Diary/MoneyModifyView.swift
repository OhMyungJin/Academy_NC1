//
//  MoneyModifyView.swift
//  Diary
//
//  Created by Simmons on 4/17/24.
//

import SwiftUI
import CoreData

struct MoneyModifyView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var dateFormat: String
    @Binding var money: [Money]
    
    @State private var expenseItems: [ExpenseItem] = [ExpenseItem(category: .고정비)]
    
    var body: some View {
        ScrollView {
            VStack {
                // Display expense items
                LazyVGrid(columns: [GridItem(.flexible())]) {
                    ForEach($expenseItems, id: \.id) { $item in
                        VStack {
                            HStack {
                                Text("분류")
                                    .frame(height: 40)
                                    .padding(.leading, 20)
                                    .padding(.top, 8)
                                Picker(
                                    "category",
                                    selection: $item.category
                                ){
                                    ForEach(Category.allCases) { category in
                                        Text(category.rawValue.capitalized)
                                    }
                                }
                                .pickerStyle(.automatic)
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(RoundedRectangle(cornerRadius: 10)
                                                .fill(.white))
                                .padding(.init(top: 16, leading: 16, bottom: 8, trailing: 16))
                            }
                            
                            HStack {
                                Text("가격")
                                    .frame(height: 40)
                                    .padding(.leading, 20)
                                TextField("", text: $item.price)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 40)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                                    .fill(.white))
                                    .padding(.leading, 16)
                                    .padding(.trailing, 16)
                            }
                            
                            HStack {
                                VStack {
                                    Text("내용")
                                        .padding(.leading, 20)
                                        .padding(.top, 24)
                                    Spacer()
                                }
                                TextEditor(text: $item.detail)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 90)
                                    .cornerRadius(10)
                                    .padding(.init(top: 8, leading: 16, bottom: 16, trailing: 16))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 244)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray))
                    }
                }
                
                // Buttons for adding and removing expense items
                HStack {
                    Button {
                        if expenseItems.count > 1 {
                            expenseItems.removeLast()
                        }
                    } label: {
                        Text("제거하기")
                            .frame(width: 147)
                            .frame(height: 40)
                            .font(.system(size:16, weight: .medium))
                            .foregroundColor(.black)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray))
                    }
                    
                    Button {
                        expenseItems.append(ExpenseItem(category: .고정비))
                    } label: {
                        Text("추가하기")
                            .frame(width: 147)
                            .frame(height: 40)
                            .font(.system(size:16, weight: .medium))
                            .foregroundColor(.black)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray))
                    }
                }
                
                Spacer()
            }
            .padding()
            .onAppear {
                expenseItems = money.map { moneyItem in
                    ExpenseItem(category: Category(rawValue: moneyItem.category!) ?? .고정비,
                                price: String(moneyItem.price ?? "0"),
                                detail: moneyItem.detail ?? "")
                }
            }
        }
        .navigationBarTitle("지출 수정하기", displayMode: .inline)
        .navigationBarItems(trailing:
            Button("완료") {
                updateItem()
            })
    }
    
    // Function to save money data
    private func updateItem() {
        let fetchRequest: NSFetchRequest<Money> = Money.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dateString == %@", dateFormat)
        
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            for existingItem in results {
                    viewContext.delete(existingItem)
                }
            // 해당 날짜에 기존에 저장되어있던 데이터 삭제 또는 덮어쓰기 구현
            
            for item in expenseItems {
                let newMoney = Money(context: viewContext)
                newMoney.dateString = dateFormat
                newMoney.category = item.category.category
                newMoney.price = item.price
                newMoney.detail = item.detail
            }
            
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving money data: \(error.localizedDescription)")
        }
    }
}

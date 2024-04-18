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
    // alert
    @State private var showingAlert = false
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0 // 소수점 없음
        return formatter
    }()
    
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
                                    .fill(Color.hexEFEFEF))
                                .padding(.init(top: 16, leading: 16, bottom: 8, trailing: 16))
                            }
                            
                            HStack {
                                Text("가격")
                                    .frame(height: 40)
                                    .padding(.leading, 20)
                                TextField("", text: $item.price)
                                    .onChange(of: item.price) { newValue in
                                        item.price = formatNumberString(input: newValue)
                                    }
                                    .padding(.leading, 8)
                                    .keyboardType(.decimalPad)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 40)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.hexEFEFEF))
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
                                    .padding(.leading, 4)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.hexEFEFEF)
//                                    .frame(maxWidth: .infinity)
//                                    .frame(height: 90)
                                    .cornerRadius(10)
                                    .padding(.init(top: 8, leading: 16, bottom: 16, trailing: 16))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 244)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.hex886D5A))
                    }
                }
                
                // Buttons for adding and removing expense items
                HStack {
                    Button {
                        withAnimation {
                            if expenseItems.count > 0 {
                                expenseItems.removeLast()
                            }
                        }
                    } label: {
                        HStack{
                            Image("remove")
                                .resizable()
                                .frame(width: 27, height: 27)
                            Text("제거하기")
                        }
                            .frame(width: 147)
                            .frame(height: 40)
                            .font(.system(size:16, weight: .medium))
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.hex677775))
                    }
                    
                    Button {
                        withAnimation {
                            expenseItems.append(ExpenseItem(category: .고정비))
                        }
                    } label: {
                        HStack{
                            Image("add")
                                .resizable()
                                .frame(width: 27, height: 27)
                            Text("추가하기")
                        }
                            .frame(width: 147)
                            .frame(height: 40)
                            .font(.system(size:16, weight: .medium))
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.hex5E3D25))
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
            if isRequiredFieldsEmpty() {
                showingAlert = true
            } else {
                updateItem()
            }
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text("아직!"), message: Text("빈칸이 없도록 작성해주세요"), dismissButton: .default(Text("확인")))
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
    
    func formatNumberString(input: String) -> String {
        let filtered = input.filter { "0123456789".contains($0) }
        let number = numberFormatter.number(from: filtered)
        return numberFormatter.string(from: number ?? 0) ?? ""
    }
    
    func isRequiredFieldsEmpty() -> Bool {
        for item in expenseItems {
            if item.price.isEmpty || item.detail.isEmpty {
                return true
            }
        }
        return false
    }
}

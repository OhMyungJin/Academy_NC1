//
//  test.swift
//  Diary
//
//  Created by Simmons on 4/16/24.
//

import SwiftUI

struct test: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: FoodEntity.entity(), sortDescriptors: []) var Food: FetchedResults<FoodEntity>
    
    @State var textFieldTitle: String = ""
    
    var body: some View {
            
        VStack(spacing: 10) {
            TextField("", text: $textFieldTitle)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(Color(UIColor.secondarySystemBackground).cornerRadius(10))
                .padding(.horizontal, 10)
            
            Button(action: {addItem()}, label: {
                Text("저장")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .foregroundColor(.black)
                    .background(Color("Peach").cornerRadius(10))
                    .padding(.horizontal, 10)
                
            })
            
            List {
                ForEach(Food) { foods in
                    //과일에 이름이 없으면 빈문자열을 생성
                    Text(foods.name ?? "아이템 없음")
                }
                .onDelete(perform: deleteItems)
            }
            
            .listStyle(PlainListStyle())
            .navigationBarTitle("음식")
        }
            
    }
    
    private func addItem() {
        withAnimation {
            //수정 부분
            let newFood = FoodEntity(context: viewContext)
            newFood.name = textFieldTitle
            //textFieldTitle을 사용 후 재설정
            textFieldTitle = ""
            
            saveItems()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            //            offsets.map { items[$0] }.forEach(viewContext.delete)
            saveItems()
        }
    }
    
    
    private func saveItems() {
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
}


#Preview {
    test().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

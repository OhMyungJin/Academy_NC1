//
//  PreviewView.swift
//  Diary
//
//  Created by Simmons on 4/16/24.
//

import SwiftUI

struct PreviewView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest(entity: DiaryDate.entity(), sortDescriptors: []) var imageMemo: FetchedResults<DiaryDate>
//    @FetchRequest(entity: Money.entity(), sortDescriptors: []) var money: FetchedResults<Money>
//    @FetchRequest(entity: Emotions.entity(), sortDescriptors: []) var emotion: FetchedResults<Emotions>
    
    // Binding하기
    @Binding var gotoRoot: Bool
    @Binding var dateFormat: String
    @Binding var imageData: UIImage?
    @Binding var memoString: String
    @Binding var expenseItems: [ExpenseItem]
    @Binding var emotions: Array<Int16>
    
    var body: some View {
        ScrollView{
            VStack{
                
                if imageData != nil {
                    Image(uiImage: imageData!)
                        .resizable()
                        .frame(width: 361, height: 361)
                    Divider()
                }
                
                HStack{
                    Text(dateFormat)
                    Spacer()
                }
                Text(memoString)
                    .frame(maxWidth: .infinity)
                
                Divider()
                
                HStack{
                    Text("지출")
                        .foregroundColor(.hex5E3D25)
                    Spacer()
                }
                
                if expenseItems.isEmpty {
                    // 지출이 없습니다 나올 수 있도록 나중에 수정
                    // 지금은 제거하기도 안되고 지출이 없을 때 어떻게 해야하는지 아이디어 찾아야함
                    Text("지출이 없습니다.")
                } else {
                    HStack{
                        Text("분류")
                        Spacer()
                        Text("가격")
                            .padding(.trailing)
                    }
                    ForEach($expenseItems, id: \.id) { $item in
                        HStack{
                            // 카테고리 출력
                            Text(item.category.category)
                            Spacer()
                            // 가격 출력
                            Text(item.price)
                        }
                    }
                }

                Divider()
                
                HStack{
                    Text("감정")
                    Spacer()
                }
                
                HStack{
                    Text("😊")
                    Text("\(emotions[0])%")
                    Spacer()
                    Text("😭")
                    Text("\(emotions[1])%")
                    Spacer()
                    Text("😡")
                    Text("\(emotions[2])%")
                }
                .padding()
                HStack{
                    Spacer()
                    Text("😅")
                    Text("\(emotions[3])%")
                    Spacer()
                    Text("😳")
                    Text("\(emotions[4])%")
                    Spacer()
                }
                
                
            }
            .padding()
        }
        .navigationBarTitle("미리보기", displayMode: .inline)
        .navigationBarItems(trailing:
            Button("완료") {
            addItem()
            gotoRoot = false
        })
    }
    
    // CoreData 추가
    private func addItem() {
        let newDiary = DiaryDate(context: viewContext)
        
        // UIImage를 Data로 변환
        if let uiImage = imageData {
            if let imageData = uiImage.jpegData(compressionQuality: 1.0) {
                newDiary.image = imageData
            }
        }
        
        newDiary.dateString = dateFormat
        newDiary.memo = memoString
        
        for item in expenseItems {
            let newMoney = Money(context: viewContext)
            newMoney.dateString = dateFormat
            newMoney.category = item.category.category
            newMoney.price = item.price
            newMoney.detail = item.detail
        }
        
        let newFeels = Emotions(context: viewContext)
        newFeels.dateString = dateFormat
        newFeels.happy = emotions[0]
        newFeels.sad = emotions[1]
        newFeels.angry = emotions[2]
        newFeels.panic = emotions[3]
        newFeels.anxiety = emotions[4]
        
        saveItems()
    }
    
    // CoreData 저장
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
    PreviewView(gotoRoot: Binding.constant(false), dateFormat: Binding.constant("Preview date"), imageData: Binding.constant(nil), memoString: Binding.constant("Preview date"), expenseItems: Binding.constant([]), emotions: Binding.constant([85,20,30,33,12])).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

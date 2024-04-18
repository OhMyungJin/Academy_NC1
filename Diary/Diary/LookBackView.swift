//
//  LookBackView.swift
//  Diary
//
//  Created by Simmons on 4/17/24.
//

import SwiftUI
import CoreData

struct LookBackView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var dateFormat: String
    
    @State private var diary: [DiaryDate] = []
    @State private var money: [Money] = []
    @State private var feels: [Emotions] = []
    
    @State private var gotoMemoModi: Bool = false
    @State private var gotoMoneyModi: Bool = false
    @State private var gotoEmoModi: Bool = false

    @State var isAppear = false
    
    @State var diaryMemo = ""
    @State var happy = 0
    @State var sad = 0
    @State var angry = 0
    @State var panic = 0
    @State var anxiety = 0
    
    var body: some View {
        ScrollView{
            VStack{
                // \.managedObjectContext, persistenceController.container.viewContext 왜쓰는지 알아보셈
                NavigationLink(destination: ImageMemoModifyView(dateFormat: $dateFormat, diary: $diary), isActive: self.$gotoMemoModi, label: {})
                NavigationLink(destination: MoneyModifyView(dateFormat: $dateFormat, money: $money), isActive: self.$gotoMoneyModi, label: {})
                NavigationLink(destination: EmotionModifyView(dateFormat: $dateFormat, feels: $feels), isActive: self.$gotoEmoModi, label: {})
                
                
                if let image = diary.first?.image,
                   let uiImage = UIImage(data: image){
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 361, height: 361)
                    Divider()
                }
                
                HStack{
                    Text(dateFormat)
                    Spacer()
                    if isAppear {
                        Button {
                            self.gotoMemoModi.toggle()
                                
                        } label: {
                            Image(systemName: "pencil")
                                .foregroundColor(.hex5E3D25)
                        }
                    }
                    
                }
                
                Text(diaryMemo)
                    .frame(maxWidth: .infinity)
                
                Divider()
                
                HStack{
                    Text("지출")
                    Spacer()
                    if isAppear {
                        Button {
                            self.gotoMoneyModi.toggle()
                        } label: {
                            Image(systemName: "pencil")
                                .foregroundColor(.hex5E3D25)
                        }
                    }
                }
                
                VStack {
                    if money.isEmpty {
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
                        
                        ForEach($money, id: \.id) { $item in
                            HStack{
                                // 카테고리 출력
                                Text(item.category!)
                                Spacer()
                                // 가격 출력
                                Text(item.price!)
                            }
                        }
                    }
                }
                
                Divider()
                
                HStack{
                    Text("감정")
                    Spacer()
                    if isAppear {
                        Button {
                            self.gotoEmoModi.toggle()
                        } label: {
                            Image(systemName: "pencil")
                                .foregroundColor(.hex5E3D25)
                        }
                    }
                }
                
                HStack{
                    Text("😊")
                    Text("\(happy)%")
                    Spacer()
                    Text("😭")
                    Text("\(sad)%")
                    Spacer()
                    Text("😡")
                    Text("\(angry)%")
                }
                .padding()
                HStack{
                    Spacer()
                    Text("😅")
                    Text("\(panic)%")
                    Spacer()
                    Text("😳")
                    Text("\(anxiety)%")
                    Spacer()
                }
            }
            .onAppear {
                loadDiaryData()
                loadMoneyData()
                loadFeelsData()
                
                if let memo = diary.first?.memo {
                    self.diaryMemo = memo
                }
                
                self.happy = Int(feels.first!.happy)
                self.sad = Int(feels.first!.sad)
                self.angry = Int(feels.first!.angry)
                self.panic = Int(feels.first!.panic)
                self.anxiety = Int(feels.first!.anxiety)
            }
            .padding()
        }
        .navigationBarTitle("돌아보기", displayMode: .inline)
        .navigationBarItems(trailing:
            Button{
            self.isAppear.toggle()
            
        } label: {
            if isAppear {
                Text("완료")
            } else {
                Text("수정")
                
            }
        })
    }
    
    private func loadDiaryData() {
        let fetchRequest: NSFetchRequest<DiaryDate> = DiaryDate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dateString == %@", dateFormat)
        fetchRequest.sortDescriptors = [] // 정렬 기준이 필요하면 여기에 추가

        do {
            diary = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching memos: \(error.localizedDescription)")
            diary = []
        }
    }
    
    private func loadMoneyData() {
        let fetchRequest: NSFetchRequest<Money> = Money.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dateString == %@", dateFormat)
        fetchRequest.sortDescriptors = [] // 정렬 기준이 필요하면 여기에 추가

        do {
            money = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching memos: \(error.localizedDescription)")
            money = []
        }
    }
    
    private func loadFeelsData() {
        let fetchRequest: NSFetchRequest<Emotions> = Emotions.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dateString == %@", dateFormat)
        fetchRequest.sortDescriptors = [] // 정렬 기준이 필요하면 여기에 추가

        do {
            feels = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching memos: \(error.localizedDescription)")
            feels = []
        }
    }
}

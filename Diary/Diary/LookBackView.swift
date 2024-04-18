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
    
    let persistenceController = PersistenceController.shared
    
    var body: some View {
        ScrollView{
            VStack{
                NavigationLink(destination: ImageMemoModifyView(dateFormat: $dateFormat, diary: $diary).environment(\.managedObjectContext, persistenceController.container.viewContext), isActive: self.$gotoMemoModi, label: {})
                NavigationLink(destination: MoneyModifyView(dateFormat: $dateFormat, money: $money).environment(\.managedObjectContext, persistenceController.container.viewContext), isActive: self.$gotoMoneyModi, label: {})
                NavigationLink(destination: EmotionModifyView(dateFormat: $dateFormat, feels: $feels).environment(\.managedObjectContext, persistenceController.container.viewContext), isActive: self.$gotoEmoModi, label: {})
                
                
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
                
                VStack {
                    if let memo = diary.first?.memo {
                        Text(memo)
                    } else { // 없을리가 없긴할텐데 일단 넣어
                        Text("No Memo")
                    }
                }
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
                    Text("\(feels.first?.happy ?? 0)%")
                    Spacer()
                    Text("😭")
                    Text("\(feels.first?.sad ?? 0)%")
                    Spacer()
                    Text("😡")
                    Text("\(feels.first?.angry ?? 0)%")
                }
                .padding()
                HStack{
                    Spacer()
                    Text("😅")
                    Text("\(feels.first?.panic ?? 0)%")
                    Spacer()
                    Text("😳")
                    Text("\(feels.first?.anxiety ?? 0)%")
                    Spacer()
                }
            }
            .onAppear {
                loadDiaryData()
                loadMoneyData()
                loadFeelsData()
            }
            .onChange(of: dateFormat) { _ in
                loadDiaryData()
                loadMoneyData()
                loadFeelsData()
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
            print(money)
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

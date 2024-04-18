//
//  CalendarView.swift
//  NC1_diary
//
//  Created by Simmons on 4/13/24.
//

import SwiftUI
import CoreData

struct CalendarView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // date에 날짜의 정보 저장
    @State private var date = Date()
    // 지정 날짜 정보 표시/전달
    @State private var dateFormat: String = ""
    // DiaryDate
    @State private var diary: [DiaryDate] = []
    // 화면 전환 여부
    @State private var gotoMemo: Bool = false
    @State private var gotoBack: Bool = false
    
    @State var memo: String = ""
    
    let persistenceController = PersistenceController.shared
    
    var body: some View {
        VStack{
            NavigationLink(destination: ImageMemoView(gotoRoot: self.$gotoMemo, dateFormat: $dateFormat), isActive: self.$gotoMemo, label: {})
            NavigationLink(destination: LookBackView(dateFormat: self.$dateFormat), isActive: self.$gotoBack, label: {})
//            MoneyView(dateFormat: $dateFormat)
            
            HStack{
                Spacer()
                // 내 정보로 가는 버튼
                Button{
                    print("내정보")
                } label: {
                    Image(systemName: "person.fill")
                        .imageScale(.large)
                        .font(.title)
                        .foregroundColor(.hex5E3D25)
                }
            }
            // 캘린더 생성
            DatePicker(
                "Start Date",
                selection: $date,
                in: ...Date.now,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .accentColor(.hex5E3D25)
            
            Divider()
            
            HStack{
                // 선택 날짜 표시
                Text(dateFormat)
                    .padding(4)
                Spacer()
            }
            
            VStack{
                if memo != "" {
                    // 메모가 있을 경우 표시
                    Text(memo)
                        .frame(maxWidth: .infinity,
                               maxHeight: .infinity)
                    // 돌아보기로 가는 버튼
                    Button {
                        print("돌아보기")
                        self.gotoBack.toggle()
                    } label: {
                        Text("돌아보기")
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .font(.system(size:16, weight: .medium))
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.hex677775))
                    }
                } else {
                    // 메모가 없을 경우 기본 문구 표시
                    Text("작성된 일기가 없습니다.")
                        .frame(maxWidth: .infinity,
                               maxHeight: .infinity)
                    // 기록하기로 가는 버튼
                    Button {
                        print("기록하기")
                        self.gotoMemo.toggle()
                    } label: {
                        Text("기록하기")
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .font(.system(size:16, weight: .medium))
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.hex5E3D25))
                    }
                }
            }
        }
        .onAppear {
            // 뷰가 나타날 때 dateFormat 설정
            dateFormat = dateFormatter.string(from: date)
            loadDiaryData()
            if let memo = diary.first?.memo {
                self.memo = memo
            } else {
                self.memo = ""
            }
        }
        .onChange(of: date) { newValue in
            // 날짜를 선택할 때 dateFormat 변경
            dateFormat = dateFormatter.string(from: newValue)
            loadDiaryData()
            if let memo = diary.first?.memo {
                self.memo = memo
            } else {
                self.memo = ""
            }
        }
        .padding()
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
}

// 날짜를 원하는 형식으로 포맷
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
//    formatter.dateStyle = .short
    formatter.dateFormat = "yyyy. MM. dd"
    return formatter
}()

#Preview {
    CalendarView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

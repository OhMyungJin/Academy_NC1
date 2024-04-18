//
//  CalendarView.swift
//  NC1_diary
//
//  Created by Simmons on 4/13/24.
//

import SwiftUI
import CoreData

struct CalendarView: View {
    
    // date에 날짜의 정보 저장
    @State private var date = Date()
    // 지정 날짜 정보 표시/전달
    @State private var dateFormat: String = ""
    
    // 화면 전환 여부
    @State private var gotoMemo: Bool = false
    @State private var gotoBack: Bool = false
    
    let persistenceController = PersistenceController.shared
    
    var body: some View {
        VStack{
            NavigationLink(destination: ImageMemoView(gotoRoot: self.$gotoMemo, dateFormat: $dateFormat), isActive: self.$gotoMemo, label: {})
            NavigationLink(destination: LookBackView(dateFormat: self.$dateFormat).environment(\.managedObjectContext, persistenceController.container.viewContext), isActive: self.$gotoBack, label: {})
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
            // 뷰가 나타날 때 dateFormat 설정
            .onAppear {
                dateFormat = dateFormatter.string(from: date)
            }
            // 날짜를 선택할 때 dateFormat 변경
            .onChange(of: date) { newValue in
                dateFormat = dateFormatter.string(from: newValue)
            }
            
            Divider()
            
            HStack{
                // 선택 날짜 표시
                Text(dateFormat)
                    .padding(4)
                Spacer()
            }
            
            VStack{
                if let memo = fetchMemoForDate(date: dateFormat) {
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
        .padding()
    }
    
    func fetchMemoForDate(date: String) -> String? {
        let context = PersistenceController.shared.container.viewContext
        
        // CoreData에서 해당 날짜에 맞는 메모를 검색
        let fetchRequest: NSFetchRequest<DiaryDate> = DiaryDate.fetchRequest()
        
        // CoreData에서 날짜에 해당하는 메모를 찾기 위한 predicate 설정
        let predicate = NSPredicate(format: "dateString == %@", date)
        fetchRequest.predicate = predicate
        
        do {
            // CoreData에서 메모를 가져오기
            let result = try context.fetch(fetchRequest)
            
            // 결과가 있는 경우 메모 반환
            if let memo = result.first {
                return memo.memo
            } else { // 결과가 없는 경우
                return nil
            }
        } catch {
            // 에러 발생 시 처리
            print("Error fetching memo for date: \(error.localizedDescription)")
            return nil
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

//
//  CalendarView.swift
//  NC1_diary
//
//  Created by Simmons on 4/13/24.
//

import SwiftUI

struct CalendarView: View {
    
    // date에 날짜의 정보 저장
    @State private var date = Date()
    // 지정 날짜 정보 표시/전달
    @State private var dateFormat: String = ""
    
    // 화면 전환 여부
    @State var gotoMemo = false
    
    var body: some View {
        VStack{
            NavigationLink(destination: ImageMemoView(dateFormat: self.$dateFormat), isActive: self.$gotoMemo, label: {})
            HStack{
                Spacer()
                // 내 정보로 가는 버튼
                Button{
                    print("내정보")
                } label: {
                    Image(systemName: "person.fill")
                        .imageScale(.large)
                        .font(.title)
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
                Spacer()
            }
            
            // 작성된 일기가 없을 때 보이는 창
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
                    .foregroundColor(.black)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray))
            }
        }
        .padding()
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

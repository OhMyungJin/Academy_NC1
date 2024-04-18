//
//  ImageMemoView.swift
//  NC1_diary
//
//  Created by Simmons on 4/14/24.
//

import SwiftUI

struct ImageMemoView: View {

    // Binding하기
    @Binding var gotoRoot: Bool
    @Binding var dateFormat: String
    
    // ImagePicker boolean값
    @State private var openPhoto = false
    // image, memo 전달용
    @State private var image: UIImage? = nil
    @State private var memoString: String = ""
    // alert
    @State private var showingAlert = false
    
    // TextEditor에 작성될 문자열
    @State var diary: String = ""
    @State var gotoMoney = false
    
    // 기본 이미지 설정
    let defaultImage = UIImage(named: "이미지추가")
    let placeholder: String = "일기를 작성해보세요!"
    
    var body: some View {
        VStack{
            NavigationLink(destination: MoneyView(gotoRoot: self.$gotoRoot, dateFormat: $dateFormat, imageData: $image, memoString: $memoString).toolbarRole(.editor), isActive: self.$gotoMoney, label: {})
//            NavigationLink(destination: CalendarView(), isActive: self.$gotoMoney, label: {})
            
            // 일단 버튼 모양 '이미지추가'로 대체
            Button {
                self.openPhoto = true
            } label: {
                Image(uiImage: self.image ?? defaultImage!)
                    .resizable()
                    .frame(width: 361, height: 361)
            }
            
            Divider()
            HStack {
                // 일단 고정값
                Text(dateFormat)
                Spacer()
            }
            ZStack {
                // 일기장 생성
                TextEditor(text: $diary)
                    .lineSpacing(10)
                    .padding(.init(top: 4, leading: 8, bottom: 0, trailing: 4))
                    .scrollContentBackground(.hidden)
                    .cornerRadius(10)
                
                // TextEditor에 placeholder기능이 없어서 따로 조건문으로 생성
                if diary.isEmpty {
                    VStack{
                        HStack{
                            Text(placeholder)
                                .foregroundColor(Color.primary.opacity(0.25))
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding()
                }
            }.overlay{
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.primary.opacity(0.25))
            }
            .shadow(radius: 4)
            
        }
        // 내비게이션 설정
        .navigationBarTitle("일기 작성하기", displayMode: .inline)
        .navigationBarItems(trailing:
                                Button("다음") {
            
            if diary.isEmpty {
                print("머쓱")
                self.showingAlert = true
            } else {
                memoString = diary
                self.gotoMoney.toggle()
            }
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text("아직!"), message: Text("일기 작성은 필수입니다"), dismissButton: .default(Text("확인")))
        })
        .padding()
        // ImagePicker 표시
        .sheet(isPresented: $openPhoto) {
            ImagePicker(selectedImage: self.$image, sourceType: .photoLibrary)
        }
       
    }
}


#Preview {
    ImageMemoView(gotoRoot: Binding.constant(false), dateFormat: Binding.constant("Preview date"))
}

//
//  ImageMemoView.swift
//  NC1_diary
//
//  Created by Simmons on 4/14/24.
//

import SwiftUI

struct ImageMemoView: View {
    
    // 날짜 받아오기
    @Binding var dateFormat: String
    
    // ImagePicker boolean값
    @State private var openPhoto = false
    @State private var image: UIImage? = nil
    
    // TextEditor에 작성될 문자열
    @State var diary: String = ""
    
    // 기본 이미지 설정
    let defaultImage = UIImage(named: "이미지추가")
    let placeholder: String = "오늘의 일기를 작성해보세요!"
    
    var body: some View {
        VStack{
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
                    .border(Color.gray, width: 3)
                
                // TextEditor에 placeholder기능이 없어서 따로 조건문으로 생성
                if diary.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color.primary.opacity(0.25))
                }
            }
            
        }
        // 내비게이션 설정
        .navigationBarTitle("일기 작성하기", displayMode: .inline)
        .navigationBarItems(trailing:
            Button("다음") {
            print("다음")
        })
        .padding()
        // ImagePicker 표시
        .sheet(isPresented: $openPhoto) {
            ImagePicker(selectedImage: self.$image, sourceType: .photoLibrary)
        }
    }
}

#Preview {
    ImageMemoView(dateFormat: Binding.constant("Preview date")).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

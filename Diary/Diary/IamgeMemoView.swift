//
//  ImageMemoView.swift
//  NC1_diary
//
//  Created by Simmons on 4/14/24.
//

import SwiftUI

struct ImageMemoView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: ImageMemo.entity(), sortDescriptors: []) var imageMemo: FetchedResults<ImageMemo>
    
    // 날짜 받아오기
    @Binding var dateFormat: String
    
    // ImagePicker boolean값
    @State private var openPhoto = false
    @State private var image: UIImage? = nil
    // TextEditor에 작성될 문자열
    @State var diary: String = ""
    @State var gotoMoney = false
    
    // 기본 이미지 설정
    let defaultImage = UIImage(named: "이미지추가")
    let placeholder: String = "오늘의 일기를 작성해보세요!"
    
    var body: some View {
        VStack{
            NavigationLink(destination: MoneyView(), isActive: self.$gotoMoney, label: {})
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
            addItem()
            self.gotoMoney.toggle()
            
        })
        .padding()
        // ImagePicker 표시
        .sheet(isPresented: $openPhoto) {
            ImagePicker(selectedImage: self.$image, sourceType: .photoLibrary)
        }
    }
    
    private func addItem() {
        let newImageMemo = ImageMemo(context: viewContext)
        
        // UIImage를 Data로 변환
        if let uiImage = self.image {
            if let imageData = uiImage.jpegData(compressionQuality: 1.0) {
                newImageMemo.image = imageData
            }
        } else if let defaultImg = defaultImage, let imageData = defaultImg.jpegData(compressionQuality: 1.0) {
            newImageMemo.image = imageData
        }
    
//        newImageMemo.image = Image(uiImage: self.image ?? defaultImage!)
        newImageMemo.memo = diary
        newImageMemo.dateString = dateFormat
        
        diary = ""
        
        saveItems()
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
    ImageMemoView(dateFormat: Binding.constant("Preview date")).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

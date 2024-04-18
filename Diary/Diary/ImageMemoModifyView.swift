//
//  ImageMemoModifyView.swift
//  Diary
//
//  Created by Simmons on 4/17/24.
//

import SwiftUI
import CoreData

struct ImageMemoModifyView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var dateFormat: String
    @Binding var diary: [DiaryDate]
    
    @State private var openPhoto = false
    @State private var image: UIImage? = nil
    // alert
    @State private var showingAlert = false
    
    @State var text: String = ""
    
    var defaultImage = UIImage(named: "이미지추가")
    
    var body: some View {
        VStack{
            
            // 일단 버튼 모양 '이미지추가'로 대체
            Button {
                self.openPhoto = true
            } label: {
                if let image = diary.first?.image,
                   let uiImage = UIImage(data: image){
                    Image(uiImage: self.image ?? uiImage)
                        .resizable()
                        .frame(width: 361, height: 361)
                } else {
                    Image(uiImage: self.image ?? defaultImage!)
                        .resizable()
                        .frame(width: 361, height: 361)
                }
            }
            
            Divider()
            HStack {
                // 일단 고정값
                Text(dateFormat)
                Spacer()
            }
            // 일기장 생성
            TextEditor(text: $text)
                .lineSpacing(10)
                .padding(.init(top: 4, leading: 8, bottom: 0, trailing: 4))
                .scrollContentBackground(.hidden)
                .cornerRadius(10)
                .overlay{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white)
                }
                .shadow(radius: 4)
            
        }
        // 내비게이션 설정
        .navigationBarTitle("일기 수정하기", displayMode: .inline)
        .navigationBarItems(trailing:
            Button("완료") {
            if text.isEmpty {
                print("머쓱")
                self.showingAlert = true
            } else {
                updateItem()
            }
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text("아직!"), message: Text("일기 작성은 필수입니다"), dismissButton: .default(Text("확인")))
        })
        .padding()
        // ImagePicker 표시
        .sheet(isPresented: $openPhoto) {
            ImagePicker(selectedImage: self.$image, sourceType: .photoLibrary)
        }
        .onAppear {
            if let memo = diary.first?.memo {
                self.text = memo
            }
        }
    }
    
    private func updateItem() {
        let fetchRequest: NSFetchRequest<DiaryDate> = DiaryDate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dateString == %@", dateFormat)

        do {
            let results = try viewContext.fetch(fetchRequest)
            if let existingDiary = results.first {
                // 해당 엔터티의 값을 업데이트
                if let uiImage = image {
                    if let imageData = uiImage.jpegData(compressionQuality: 1.0) {
                        existingDiary.image = imageData
                    }
                }
                existingDiary.memo = text
            }

            // 변경 사항 저장
            try viewContext.save()
            dismiss() // 성공적으로 업데이트 후 화면 전환
        } catch {
            print("Error updating item: \(error.localizedDescription)")
        }
    }

}

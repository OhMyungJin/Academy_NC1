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
                .border(Color.gray, width: 3)
            
        }
        // 내비게이션 설정
        .navigationBarTitle("일기 수정하기", displayMode: .inline)
        .navigationBarItems(trailing:
            Button("완료") {
            if text.isEmpty {
                print("머쓱")
            } else {
                updateItem()
//                backtoModi = false
            }
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
            if let diaryDate = results.first {
                // 이미지와 메모 업데이트
                if let newImage = image {
                    diaryDate.image = newImage.jpegData(compressionQuality: 1.0)
                }
                diaryDate.memo = text

                // 변경 사항 저장
                try viewContext.save()
                dismiss() // 성공적으로 업데이트 후 화면 전환
                
            } else {
                print("DiaryDate 엔티티를 찾을 수 없습니다.")
            }
        } catch {
            print("Error updating item: \(error.localizedDescription)")
        }
    }

}

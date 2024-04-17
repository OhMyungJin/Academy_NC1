//
//  EmotionModifyView.swift
//  Diary
//
//  Created by Simmons on 4/17/24.
//

import SwiftUI
import CoreData

struct EmotionModifyView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var dateFormat: String
    @Binding var feels: [Emotions]
    
    @State private var sliderValue1 = 0.0
    @State private var sliderValue2 = 0.0
    @State private var sliderValue3 = 0.0
    @State private var sliderValue4 = 0.0
    @State private var sliderValue5 = 0.0
    
    var minimumValue = 0.0
    var maximumValue = 100.0
    
    var body: some View {
        VStack{
            Spacer()
            
            Text("하루의 감정을 수치로 나타내보세요!")
            
            Spacer()
            
            Divider()
            
            Spacer()
            
            Text("행복😊")
            // Slider 구현
            HStack {
                
                Slider(value: $sliderValue1, in: minimumValue...maximumValue)
                    .accentColor(.orange)
                
                Text("\(Int(sliderValue1))")
                    .frame(width: 40)
            }
            .padding(.init(top: 0, leading: 16, bottom: 24, trailing: 16))
            
            Text("슬픔😭")
            HStack {
                
                Slider(value: $sliderValue2, in: minimumValue...maximumValue)
                    .accentColor(.orange)
                
                Text("\(Int(sliderValue2))")
                    .frame(width: 40)
            }
            .padding(.init(top: 0, leading: 16, bottom: 24, trailing: 16))
            
            Text("분노😡")
            HStack {
                
                Slider(value: $sliderValue3, in: minimumValue...maximumValue)
                    .accentColor(.orange)
                
                Text("\(Int(sliderValue3))")
                    .frame(width: 40)
            }
            .padding(.init(top: 0, leading: 16, bottom: 24, trailing: 16))
            
            Text("당황😅")
            HStack {
                
                Slider(value: $sliderValue4, in: minimumValue...maximumValue)
                    .accentColor(.orange)
                
                Text("\(Int(sliderValue4))")
                    .frame(width: 40)
            }
            .padding(.init(top: 0, leading: 16, bottom: 24, trailing: 16))
            
            Text("불안😳")
            HStack {
                
                Slider(value: $sliderValue5, in: minimumValue...maximumValue)
                    .accentColor(.orange)
                
                Text("\(Int(sliderValue5))")
                    .frame(width: 40)
            }
            .padding(.init(top: 0, leading: 16, bottom: 24, trailing: 16))
            
            Spacer()
        }
        .onAppear {
            self.sliderValue1 = Double(feels.first!.happy)
            self.sliderValue2 = Double(feels.first!.sad)
            self.sliderValue3 = Double(feels.first!.angry)
            self.sliderValue4 = Double(feels.first!.panic)
            self.sliderValue5 = Double(feels.first!.anxiety)
        }
        .navigationBarTitle("감정 수정하기", displayMode: .inline)
        .navigationBarItems(trailing:
            Button("완료") {
            updateItem()
        })
    }
    
    private func updateItem() {
        let fetchRequest: NSFetchRequest<Emotions> = Emotions.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dateString == %@", dateFormat)

        do {
            let results = try viewContext.fetch(fetchRequest)
            if let existingEmotion = results.first {
                // 해당 엔터티의 값을 업데이트합니다.
                existingEmotion.happy = Int16(sliderValue1)
                existingEmotion.sad = Int16(sliderValue2)
                existingEmotion.angry = Int16(sliderValue3)
                existingEmotion.panic = Int16(sliderValue4)
                existingEmotion.anxiety = Int16(sliderValue5)
            }

            // 변경 사항 저장
            try viewContext.save()
            dismiss() // 성공적으로 업데이트 후 화면 전환
        } catch {
            print("Error updating item: \(error.localizedDescription)")
        }
    }
}

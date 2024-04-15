//
//  EmotionView.swift
//  Diary
//
//  Created by Simmons on 4/15/24.
//

import SwiftUI

struct EmotionView: View {
    
    // 각 감정의 수치
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
        .navigationBarTitle("지출 작성하기", displayMode: .inline)
        .navigationBarItems(trailing:
            Button("완료") {
                print("완료")
        })
    }
}

#Preview {
    EmotionView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

//
//  EmotionView.swift
//  Diary
//
//  Created by Simmons on 4/15/24.
//

import SwiftUI

struct EmotionView: View {
    
    // Binding하기
    @Binding var gotoRoot: Bool
    @Binding var dateFormat: String
    @Binding var imageData: UIImage?
    @Binding var memoString: String
    @Binding var expenseItems: [ExpenseItem]
    
    @State private var emotions: Array<Int16> = []
    
    // 각 감정의 수치
    @State private var sliderValue1 = 0.0
    @State private var sliderValue2 = 0.0
    @State private var sliderValue3 = 0.0
    @State private var sliderValue4 = 0.0
    @State private var sliderValue5 = 0.0
    
    @State var gotoPre = false
    
    let persistenceController = PersistenceController.shared
    
    var minimumValue = 0.0
    var maximumValue = 100.0
    
    var body: some View {
        VStack{
            NavigationLink(destination: PreviewView(gotoRoot: self.$gotoRoot, dateFormat: $dateFormat, imageData: $imageData, memoString: $memoString, expenseItems: $expenseItems, emotions: $emotions), isActive: self.$gotoPre, label: {})
            
            Spacer()
            
            Text("하루의 감정을 수치로 나타내보세요!")
            
            Spacer()
            
            Divider()
            
            Spacer()
            
            Text("행복😊")
            // Slider 구현
            HStack {
                
                Slider(value: $sliderValue1, in: minimumValue...maximumValue)
                    .accentColor(.hexFFDCAB)
                
                Text("\(Int(sliderValue1))%")
                    .frame(width: 50)
            }
            .padding(.init(top: 0, leading: 16, bottom: 24, trailing: 16))
            
            Text("슬픔😭")
            HStack {
                
                Slider(value: $sliderValue2, in: minimumValue...maximumValue)
                    .accentColor(.hexFFDCAB)
                
                Text("\(Int(sliderValue2))%")
                    .frame(width: 50)
            }
            .padding(.init(top: 0, leading: 16, bottom: 24, trailing: 16))
            
            Text("분노😡")
            HStack {
                
                Slider(value: $sliderValue3, in: minimumValue...maximumValue)
                    .accentColor(.hexFFDCAB)
                
                Text("\(Int(sliderValue3))%")
                    .frame(width: 50)
            }
            .padding(.init(top: 0, leading: 16, bottom: 24, trailing: 16))
            
            Text("당황😅")
            HStack {
                
                Slider(value: $sliderValue4, in: minimumValue...maximumValue)
                    .accentColor(.hexFFDCAB)
                
                Text("\(Int(sliderValue4))%")
                    .frame(width: 50)
            }
            .padding(.init(top: 0, leading: 16, bottom: 24, trailing: 16))
            
            Text("불안😳")
            HStack {
                
                Slider(value: $sliderValue5, in: minimumValue...maximumValue)
                    .accentColor(.hexFFDCAB)
                
                Text("\(Int(sliderValue5))%")
                    .frame(width: 50)
            }
            .padding(.init(top: 0, leading: 16, bottom: 24, trailing: 16))
            
            Spacer()
        }
        .navigationBarTitle("감정 기록하기", displayMode: .inline)
        .navigationBarItems(trailing:
            Button("다음") {
            emotions = [Int16(sliderValue1), Int16(sliderValue2), Int16(sliderValue3), Int16(sliderValue4), Int16(sliderValue5)]
            self.gotoPre.toggle()
        })
    }
}

#Preview {
    EmotionView(gotoRoot: Binding.constant(false), dateFormat: Binding.constant("Preview date"), imageData: Binding.constant(nil), memoString: Binding.constant("Preview date"), expenseItems: Binding.constant([])).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

//
//  MoneyView.swift
//  Diary
//
//  Created by Simmons on 4/15/24.
//

import SwiftUI

struct MoneyView: View {
    
    
//    let gridData = Array(0...num)
    let columns = [GridItem(.flexible())]
    
    @State var num: Int = 1
    
    var body: some View {
        VStack{
            LazyVGrid(columns: columns) {
                ForEach((0...num), id: \.self) {i in
                    VStack {
                        Rectangle()
                            .frame(height: 244)
                        
                    }
                }
            }
            
            HStack {
                Button{
                    num -= 1
                } label: {
                    Text("제거하기")
                        .frame(width: 147)
                        .frame(height: 40)
                        .font(.system(size:16, weight: .medium))
                        .foregroundColor(.black)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray))
                }
                
                Button {
                    num += 1
                } label: {
                    Text("추가하기")
                        .frame(width: 147)
                        .frame(height: 40)
                        .font(.system(size:16, weight: .medium))
                        .foregroundColor(.black)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray))
                }
            }
            
            Spacer()
            
        }
        // 내비게이션 설정
        .navigationBarTitle("지출 작성하기", displayMode: .inline)
        .navigationBarItems(trailing:
            Button("다음") {
            print("다음")
        })
        .padding()
    }
}

#Preview {
    MoneyView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

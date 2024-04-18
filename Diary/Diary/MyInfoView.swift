//
//  MyInfoView.swift
//  Diary
//
//  Created by Simmons on 4/18/24.
//

import SwiftUI

struct MyInfoView: View {
    var body: some View {
        VStack{
            HStack{
                Button {
                    print("감정")
                } label: {
                    Text("월별 감정 상태")
                }
                
                Button {
                    print("지출")
                } label: {
                    Text("월별 지출 상태")
                }
            }
        }
        // 내비게이션 설정
        .navigationBarTitle("내 정보", displayMode: .inline)
    }
}

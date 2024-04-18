//
//  MoneyView.swift
//  Diary
//
//  Created by Simmons on 4/15/24.
//

import SwiftUI

// 지출 항목의 카테고리를 열거형으로 정의
// CaseIterable를 사용하여 모든 케이스에 접근 가능
enum Category: String, CaseIterable, Identifiable {
    case 고정비, 생활비, 활동비, 친목비, 꾸밈비, 차량비, 기여비, 예비비
    
    // 카테고리 이름 반환
    var category: String {
        switch self {
        case .고정비: return "고정비"
        case .생활비: return "생활비"
        case .활동비: return "활동비"
        case .친목비: return "친목비"
        case .꾸밈비: return "꾸밈비"
        case .차량비: return "차량비"
        case .기여비: return "기여비"
        case .예비비: return "예비비"
        }
    }
    
    // Identifiable 프로토콜을 충족하기 위한 id 속성
    var id: Self { self }
}

// 지출 항목
struct ExpenseItem {
    var id: UUID = UUID() // 고유 식별자
    var category: Category // 분류
    var price: String = "" // 가격
    var detail: String = "" // 내용
}

struct MoneyView: View {
    
    // Binding하기
    @Binding var gotoRoot: Bool
    @Binding var dateFormat: String
    @Binding var imageData: UIImage?
    @Binding var memoString: String
    
    // expenseItems 초기화, category 값을 '.고정비'로 지정
    @State private var expenseItems: [ExpenseItem] = [ExpenseItem(category: .고정비)]
    
    @State var gotoEmo = false
    
    var body: some View {
        ScrollView{
            VStack {
                NavigationLink(destination: EmotionView(gotoRoot: self.$gotoRoot, dateFormat: $dateFormat, imageData: $imageData, memoString: $memoString, expenseItems: $expenseItems), isActive: self.$gotoEmo, label: {})
                //            NavigationLink(destination: test().environment(\.managedObjectContext, persistenceController.container.viewContext), isActive: self.$gotoEmo, label: {})
                
                // 지출 항목을 그리드 형식으로 표시
                LazyVGrid(columns: [GridItem(.flexible())]) {
                    // 항목 개수만큼 반복
                    ForEach($expenseItems, id: \.id) { $item in
                        VStack {
                            HStack {
                                Text("분류")
                                    .frame(height: 40)
                                    .padding(.leading, 20)
                                    .padding(.top, 8)
//                                    .foregroundColor(.white)
                                // Picker를 사용하여 분류 선택
                                Picker(
                                    "category",
                                    selection: $item.category
                                ){
                                    ForEach(Category.allCases) { category in
                                        Text(category.rawValue.capitalized)
                                    }
                                }
                                .pickerStyle(.automatic)
                                .accentColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.hexEFEFEF))
                                .padding(.init(top: 16, leading: 16, bottom: 8, trailing: 16))
                            }
                            
                            // 가격 입력
                            HStack {
                                Text("가격")
                                    .frame(height: 40)
                                    .padding(.leading, 20)
//                                    .foregroundColor(.white)
//                                TextField("", value: $item.price, formatter: NumberFormatter())
                                TextField("", text: $item.price)
                                    .keyboardType(.decimalPad)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 40)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.hexEFEFEF))
                                    .padding(.leading, 16)
                                    .padding(.trailing, 16)
                            }
                            
                            // 내용 입력
                            HStack {
                                VStack {
                                    Text("내용")
                                        .padding(.leading, 20)
                                        .padding(.top, 16)
//                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                TextEditor(text: $item.detail)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.hexEFEFEF)
                                    .cornerRadius(10)
//                                    .frame(maxWidth: .infinity)
//                                    .frame(height: 90)
                                    .padding(.init(top: 8, leading: 16, bottom: 16, trailing: 16))
                                
                            }
                            
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 244)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.hex886D5A))
                        
                    }
                }
                
                HStack {
                    // 마지막 지출 항목 제거
                    Button {
                        if expenseItems.count > 1 {
                            expenseItems.removeLast()
                        }
                    } label: {
//                        Image("remove")
//                            .resizable()
//                            .frame(width: 27, height: 27)
                        Text("제거하기")
                            .frame(width: 147)
                            .frame(height: 40)
                            .font(.system(size:16, weight: .medium))
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.hex677775))
                    }
                    // 새 지출 항목 추가
                    Button {
                        print(dateFormat)
                        expenseItems.append(ExpenseItem(category: .고정비))
                    } label: {
                        Text("추가하기")
                            .frame(width: 147)
                            .frame(height: 40)
                            .font(.system(size:16, weight: .medium))
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.hex5E3D25))
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitle("지출 작성하기", displayMode: .inline)
        .navigationBarItems(trailing:
            Button("다음") {
            self.gotoEmo.toggle()
        })
    }
}


#Preview {
    MoneyView(gotoRoot: Binding.constant(false), dateFormat: Binding.constant("Preview date"), imageData: Binding.constant(nil), memoString: Binding.constant("Preview date")).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

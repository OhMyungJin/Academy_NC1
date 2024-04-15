//
//  ImagePicker.swift
//  NC1_diary
//
//  Created by Simmons on 4/14/24.
//

import SwiftUI

// 'UIViewControllerRepresentable' 프로토콜을 준수하는 구조체로
// SwiftUI 뷰에서 UIKit의 View Controller를 표시하기 위해 사용
struct ImagePicker: UIViewControllerRepresentable {
    
    // 바인딩된 UIImage - 선택된 이미지 표시
    @Binding var selectedImage: UIImage?
    // SwiftUI에서 제공하는 환경 값으로, 모달로 표시된 뷰를 닫는데 사용
    @Environment(\.presentationMode) private var presentationMode
    
    // 선택된 이미지가 없는 경우 기본 이미지로 설정
    var defaultImage: UIImage? = UIImage(named: "이미지추가")
    // UIImagePickerController에서 사용할 이미지 소스의 타입을 지정(.photoLibrary, .camera 등)
    var sourceType: UIImagePickerController.SourceType
    
    // ImagePicker의 초기화 메서드
    init(selectedImage: Binding<UIImage?>, sourceType: UIImagePickerController.SourceType, defaultImage: UIImage? = nil) {
        _selectedImage = selectedImage
        self.sourceType = sourceType
        self.defaultImage = defaultImage
    }
    
    // UIViewControllerRepresentable 프로토콜에서 요구되는 메서드
    // UIImagePickerController를 생성하고 설정
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        // 이거 이미지 비율 되는건지 나중에 확인
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    // UIViewControllerRepresentable 프로토콜에서 요구되는 메서드
    // 이미지 피커가 업데이트될 때 호출
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    // UIImagePickerController의 delegate를 처리하는 클래스
    // 이미지가 선택되면 해당 이미지를 selectedImage에 할당하고 이미지 피커를 닫음
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

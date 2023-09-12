//
//  CompactTextField.swift
//  RingtoneForest
//
//  Created by Thu Truong on 9/12/23.
//

import Foundation
import SwiftUI

struct CompatTextField: UIViewRepresentable {
    let text: Binding<String>
    let placeHolder: String
    let onSubmit: (() -> Void)?
    let onEditBegin: (() -> Void)?
    let returnKeyType: UIReturnKeyType
    let firstResponder: Bool
    let size: Int
    let textPlaceholderColor: ColorAsset
    let textColor: ColorAsset
    
    init(_ placeHolder: String, firstResponder: Bool, text: Binding<String>, returnKeyType: UIReturnKeyType, size: Int, textPlaceholderColor: ColorAsset, textColor: ColorAsset, onEditBegin: (() -> Void)? = nil, onSubmit: (() -> Void)? = nil) {
        self.text = text
        self.placeHolder = placeHolder
        self.returnKeyType = returnKeyType
        self.onSubmit = onSubmit
        self.onEditBegin = onEditBegin
        self.firstResponder = firstResponder
        self.size = size
        self.textPlaceholderColor = textPlaceholderColor
        self.textColor = textColor
    }
    
    func makeCoordinator() -> CompatTextFieldCoordinator {
        return CompatTextFieldCoordinator(text: self.text, onEditBegin: self.onEditBegin,  onSubmit: self.onSubmit)
    }
    
    func makeUIView(context: Context) -> some UIView {
        let uiView = UITextField()
        uiView.delegate = context.coordinator
        uiView.returnKeyType = returnKeyType
        uiView.autocorrectionType = .no
        uiView.font = UIFont(name: "SFProDisplay-Regular", size: CGFloat(size))
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        uiView.addTarget(context.coordinator, action: #selector(context.coordinator.textFieldDidChange(_:)), for: .editingChanged)
        uiView.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [ .foregroundColor : UIColor(asset: textPlaceholderColor), .font: UIFont.systemFont(ofSize: CGFloat(size)) ])
        uiView.textColor = UIColor(asset: textColor)
        if firstResponder {
            uiView.becomeFirstResponder()
        }
        
        return uiView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
//        (uiView as! UITextField).text = text.wrappedValue
//        (uiView as! UITextField).attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [ .foregroundColor : UIColor.fromHex(hex: "#FAFAFA"), .font : UIFont.systemFont(ofSize: 12) ])
        if text.wrappedValue == "" {
            (uiView as! UITextField).text = ""
        }
    }
}

class CompatTextFieldCoordinator: NSObject, UITextFieldDelegate {
    let text: Binding<String>
    let onSubmit: (() -> Void)?
    let onEditBegin: (() -> Void)?
    
    init(text: Binding<String>, onEditBegin: (() -> Void)?, onSubmit: (() -> Void)? = nil) {
        self.text = text
        self.onSubmit = onSubmit
        self.onEditBegin = onEditBegin
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        text.wrappedValue = textField.text ?? ""
        textField.resignFirstResponder()
      
        self.onSubmit?()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.onEditBegin?()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        text.wrappedValue = textField.text ?? ""
    }
}

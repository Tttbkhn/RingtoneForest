//
//  ViewExt.swift
//  RingtoneForest
//
//  Created by Thu Trương on 12/09/2023.
//

import Foundation
import SwiftUI

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
          GeometryReader { geometryProxy in
            Color.clear
              .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
          }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

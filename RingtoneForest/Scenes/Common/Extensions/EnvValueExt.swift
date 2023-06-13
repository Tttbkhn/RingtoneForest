//
//  EnvValueExt.swift
//  RingtoneForest
//
//  Created by Thu Trương on 13/06/2023.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    var C: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}

private extension UIEdgeInsets {
    var swiftUIInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        UIApplication.shared.keyWindow?.safeAreaInsets.swiftUIInsets ?? EdgeInsets()
    }
}

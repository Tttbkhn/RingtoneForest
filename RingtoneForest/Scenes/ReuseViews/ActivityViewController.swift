//
//  ActivityViewController.swift
//  RingtoneForest
//
//  Created by Thu Truong on 6/21/23.
//

import UIKit
import SwiftUI

struct ActivityViewController: UIViewControllerRepresentable {
    @Binding var activityItems: URL
    var applicationActivities: [UIActivity]? = nil
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> ActivityViewWrapper {
        ActivityViewWrapper(activityItems: activityItems, applicationActivities: applicationActivities, isPresented: $isPresented)
    }
    
    func updateUIViewController(_ uiViewController: ActivityViewWrapper, context: Context) {
        uiViewController.isPresented = $isPresented
        uiViewController.activityItems = activityItems
        uiViewController.updateState()
    }
}
class ActivityViewWrapper: UIViewController {
    var activityItems: URL
    var applicationActivities: [UIActivity]?
    
    var isPresented: Binding<Bool>
    
    init(activityItems: URL, applicationActivities: [UIActivity]? = nil, isPresented: Binding<Bool>) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
        self.isPresented = isPresented
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        updateState()
    }
    
    func updateState() {
        guard parent != nil else { return }
        let isActivityPresented = presentedViewController != nil
        if isActivityPresented != isPresented.wrappedValue {
            if !isActivityPresented {
                let controller = UIActivityViewController(activityItems: [activityItems], applicationActivities: applicationActivities)
                controller.completionWithItemsHandler = { (activityType, completed, _, _) in
                    self.isPresented.wrappedValue = false
                }
                
                self.present(controller, animated: true, completion: nil)
            } else {
                self.presentedViewController?.dismiss(animated: true)
            }
        }
    }
}

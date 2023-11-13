//
//  ActivityView.swift
//  FoodPin
//
//  Created by 郑敏 on 2023/11/13.
//

import SwiftUI

struct ActivityView: UIViewControllerRepresentable {
    
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return activityController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

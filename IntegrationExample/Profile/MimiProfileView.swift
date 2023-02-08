//
//  MimiProfileView.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 29.12.22.
//

import SwiftUI
import MimiSDK

struct MimiProfileView: UIViewControllerRepresentable {
    
    let configuration: MimiProfileConfiguration
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return MimiProfileViewController(configuration: configuration)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // no-op
    }
}

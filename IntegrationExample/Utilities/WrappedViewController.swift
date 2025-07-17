//
//  WrappedViewController.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 17.07.25.
//

import SwiftUI

struct WrappedViewController: UIViewControllerRepresentable, Identifiable {
    let id = UUID()
    let viewController: UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

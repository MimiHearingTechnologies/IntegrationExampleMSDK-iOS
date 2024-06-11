//
//  HeadphoneConnectivityView.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 10.05.24.
//

import SwiftUI

struct HeadphoneConnectivityView: View {

    @ObservedObject private var viewModel: HeadphoneConnectivityViewModel

    init(viewModel: HeadphoneConnectivityViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 24.0) {
            Text("Headphone Connectivity")
                .font(.title2)
            HStack {
                Toggle("Headphones connected",
                       isOn: Binding<Bool>(get: { viewModel.isHeadphoneConnected},
                                           set: { viewModel.simulateHeadphoneConnection(isConnected: $0) }))
            }
        }
    }
}

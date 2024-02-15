//
//  ProcessingView.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 30.12.22.
//

import SwiftUI
import Combine
import MimiCoreKit

struct ProcessingView: View {

    @ObservedObject private var viewModel: ProcessingViewModel
    
    init(viewModel: ProcessingViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 64) {
            connectivityView
            
            parametersView
                .opacity(viewModel.isHeadphoneConnected ? 1 : 0)
        }
        .padding(.horizontal, 32)
    }
    
    private var connectivityView: some View {
        VStack {
            Text("Headphone Connectivity")
                .font(.title2)
            HStack {
                Toggle("Headphones connected", 
                       isOn: Binding<Bool>(get: { viewModel.isHeadphoneConnected},
                                           set: { viewModel.simulateHeadphoneConnection(isConnected: $0) }))
            }
        }
    }
    
    private var parametersView: some View {
        VStack(spacing: 32.0) {
            Text("Mimi Processing Parameters")
                .font(.title2)
            HStack {
                Toggle("IsEnabled", isOn: Binding<Bool>(get: { viewModel.isEnabled }, set: { value in
                    viewModel.applyIsEnabled(value)
                }))
            }
            VStack(spacing: 4.0) {
                HStack {
                    Text("Intensity")
                    Spacer()
                    Text("\(viewModel.intensity)")
                }
                Slider(value:Binding<Float>(get: { viewModel.intensity }, set: { value in
                    viewModel.applyIntensity(value)
                })) {
                    Text("Intensity")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("1")
                }
            }
            VStack {
                HStack {
                    Text("Preset")
                    Spacer()
                    Text(viewModel.presetId ?? "nil")
                        .font(.caption)
                }
                if viewModel.isUserLoggedIn {
                    Button("Reload") {
                        viewModel.reloadPreset()
                    }
                    .buttonStyle(.bordered)
                } else {
                    Text("⚠️ User not logged in")
                }
            }
        }
    }
}

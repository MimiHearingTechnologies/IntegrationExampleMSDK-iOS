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

    @State private var session: MimiProcessingSession?

    let processing: MimiProcessingController
    let auth: MimiAuthController
    let headphoneConnectivity: PartnerHeadphoneConnectivityController

    init(processing: MimiProcessingController, auth: MimiAuthController, headphoneConnectivity: PartnerHeadphoneConnectivityController) {
        self.processing = processing
        self.auth = auth
        self.headphoneConnectivity = headphoneConnectivity
    }

    var body: some View {
        VStack(spacing: 64) {
            HeadphoneConnectivityView(viewModel: HeadphoneConnectivityViewModel(headphoneConnectivity: headphoneConnectivity) )

            if let session {
                ProcessingParameterView(viewModel: ProcessingViewModel(session: session, auth: auth))
                FineTuningView(viewModel: FineTuningViewModel(presetParameter: session.preset))
            } else {
                Text("Mimi Processing Session Unavailable")
            }
            Spacer()
        }
        .padding(.top, 40)
        .padding(.horizontal, 32)
        .onReceive(processing.sessionPublisher.receive(on: DispatchQueue.main), perform: { session in
            self.session = session
        })
    }
}

struct ProcessingParameterView: View {

    @ObservedObject private var viewModel: ProcessingViewModel

    init(viewModel: ProcessingViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 32.0) {
            Text("Mimi Processing Parameters")
                .font(.title2)
            HStack {
                Toggle("IsEnabled", isOn: Binding<Bool>(get: { viewModel.isEnabled },
                                                        set: { viewModel.applyIsEnabled($0) }))
            }
            VStack(spacing: 4.0) {
                HStack {
                    Text("Intensity")
                    Spacer()
                    Text("\(viewModel.intensity)")
                }

                DebouncedSlider(value: Binding<Float>(get: { viewModel.intensity },
                                                      set: { viewModel.applyIntensity($0) })) {
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

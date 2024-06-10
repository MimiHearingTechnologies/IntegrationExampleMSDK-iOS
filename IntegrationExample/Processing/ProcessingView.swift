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
        VStack(spacing: 48) {
            HeadphoneConnectivityView(viewModel: HeadphoneConnectivityViewModel(headphoneConnectivity: headphoneConnectivity) )

            if let session {
                ProcessingParametersView(viewModel: ProcessingParametersViewModel(session: session, auth: auth))
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

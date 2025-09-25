//
//  ContentView.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 28.12.22.
//

import SwiftUI
import MimiSDK
import MimiCoreKit

struct ContentView: View {
    
    private let headphoneConnectivity: PartnerHeadphoneConnectivityController
    private let mimiProfileConfiguration = MimiProfileConfiguration()

    init(headphoneConnectivity: PartnerHeadphoneConnectivityController) {
        self.headphoneConnectivity = headphoneConnectivity
    }
    
    var body: some View {
        TabView {
            MimiProfileView(configuration: mimiProfileConfiguration)
                .tabItem {
                    Label("Profile", systemImage: "platter.2.filled.iphone")
                }

            TestFlowView()
                .tabItem {
                    Label("TestFlow", systemImage: "ear")
                }

            ProcessingView(processing: MimiCore.shared.processing, auth: MimiCore.shared.auth, headphoneConnectivity: headphoneConnectivity)
                .tabItem {
                    Label("Processing", systemImage: "waveform")
                }

            CoreView()
                .tabItem {
                    Label("Core", systemImage: "wrench.and.screwdriver")
                }
                .navigationTitle("Core")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(headphoneConnectivity: PartnerHeadphoneConnectivityController())
    }
}

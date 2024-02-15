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

    private var headphoneConnectivity: PartnerHeadphoneConnectivityController

    init(headphoneConnectivity: PartnerHeadphoneConnectivityController) {
        self.headphoneConnectivity = headphoneConnectivity
    }

    var body: some View {
        TabView {
            MimiProfileView(configuration: MimiProfileConfiguration())
                .tabItem {
                    Label("Profile", systemImage: "platter.2.filled.iphone")
                }

            ProcessingView(viewModel: ProcessingViewModel(headphoneConnectivity: headphoneConnectivity))
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

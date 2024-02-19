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
    private let mimiProfileConfiguration: MimiProfileConfiguration
    init(headphoneConnectivity: PartnerHeadphoneConnectivityController) {
        self.headphoneConnectivity = headphoneConnectivity
//        You can set `uiControlDebounceBehavior`, if you want to have a debounce behavior applied to the Processing UI controls on the Mimi Profile.
        self.mimiProfileConfiguration = MimiProfileConfiguration(personalization: MimiPersonalizationConfiguration(uiControlDebounceBehavior: .debounce(seconds: 0.1)))
    }

    var body: some View {
        TabView {
            MimiProfileView(configuration: mimiProfileConfiguration)
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

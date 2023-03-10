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
    var body: some View {
        TabView {
            MimiProfileView(configuration: MimiProfileConfiguration())
                .tabItem {
                    Label("Profile", systemImage: "platter.2.filled.iphone")
                }
            
            Group {
                if let session = MimiCore.shared.processing.session.value {
                    ProcessingView(viewModel: ProcessingViewModel(session: session, authController: MimiCore.shared.auth))
                } else {
                    Text("Mimi Processing Session Unavailable")
                }
            }
            .tabItem {
                Label("Processing", systemImage: "waveform")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

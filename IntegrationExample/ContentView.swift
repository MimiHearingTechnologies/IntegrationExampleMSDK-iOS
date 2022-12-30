//
//  ContentView.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 28.12.22.
//

import SwiftUI
import MimiSDK

struct ContentView: View {
    var body: some View {
        TabView {
            MimiProfileView(configuration: MimiProfileConfiguration())
                .tabItem {
                    Label("Profile", systemImage: "platter.2.filled.iphone")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

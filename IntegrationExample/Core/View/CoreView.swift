//
//  CoreView.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 30.03.23.
//

import SwiftUI
import MimiCoreKit

struct CoreView: View {
    var body: some View {
        VStack {
            List {
                Section(header: Text("Test")) {
                    TestView()
                }
            }
            Text("MimiCore version \(MimiCore.version)")
                .font(.caption)
                .padding(.bottom, 16.0)
        }
    }
}

struct CoreView_Previews: PreviewProvider {
    static var previews: some View {
        CoreView()
    }
}

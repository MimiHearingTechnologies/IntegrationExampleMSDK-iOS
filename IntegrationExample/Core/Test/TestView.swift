//
//  TestView.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 30.03.23.
//

import SwiftUI
import MimiCoreKit

struct TestView: View {
    
    @ObservedObject var viewModel = TestViewModel(testController: MimiCore.shared.test)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text("Latest Results")
                .font(.headline)
            VStack {
                Text("MT: \(viewModel.latestMTHearingGrade)")
                Text("PTT: \(viewModel.latestPTTHearingGrade)")
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

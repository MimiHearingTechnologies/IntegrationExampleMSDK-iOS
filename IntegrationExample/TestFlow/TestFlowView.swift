//
//  TestFlowView.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 17.07.25.
//

import SwiftUI
import MimiTestKit
import MimiCoreKit

struct TestFlowView: View {

    let testFlowBuilder = TestFlowBuilder(authController: MimiCore.shared.auth)

    @State var testFlowViewController: WrappedViewController?

    var body: some View {
        VStack {
            Button {
                Task {
                    let testFlowInfo = try await testFlowBuilder.makeTestFlowForPresentation()
                    self.testFlowViewController = WrappedViewController(viewController: testFlowInfo.testFlowViewController)
                }

            } label: {
                Text("Launch TestFlow")
            }

        }
        .sheet(item: $testFlowViewController, content: { $0 })
    }
}

struct TestFlowView_Previews: PreviewProvider {
    static var previews: some View {
        TestFlowView()
    }
}

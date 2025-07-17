//
//  TestFlowBuilder.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 17.07.25.
//

import SwiftUI
import MimiTestKit
import MimiCoreKit

protocol TestFlowBuilding {

    func makeTestFlowForPresentation() async throws -> (testFlowViewController: UIViewController, completion: (() -> Void))
}

final class TestFlowBuilder: TestFlowBuilding {

    private let authController: MimiAuthController

    init(authController: MimiAuthController) {
        self.authController = authController
    }

    @MainActor func makeTestFlowForPresentation() async throws -> (testFlowViewController: UIViewController, completion: (() -> Void)) {
        try await authenticateAnonymouslyIfNeeded()
        let flow = try await MimiTestFlow.build()

        return try flow.makeViewControllerForPresentation()
    }

    private func authenticateAnonymouslyIfNeeded() async throws {
        if authController.currentUser != nil {
            return
        } else {
            try await withCheckedThrowingContinuation { continuation in
                authController.authenticate(route: .anonymously) { result in
                    switch result {
                    case .success:
                        continuation.resume()
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
}

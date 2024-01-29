//
//  PartnerHeadphoneConnectivityController.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 18.07.23.
//

import Foundation
import MimiCoreKit
import Combine

/// A mock headphone connectivity controller which simulates headphone connection and provides information on the currently connected headphone to the MSDK
/// Documentation: https://mimihearingtechnologies.github.io/SDKDocs-iOS/master/connected-headphone-identification.html
final class PartnerHeadphoneConnectivityController: MimiConnectedHeadphoneProvider {
    
    enum ConnectivityState {
        case disconnected
        case connected(model: String)
    }
    
    var state: CurrentValueSubject<ConnectivityState, Never> = CurrentValueSubject(.disconnected)

    func getMimiHeadphoneIdentifier() -> MimiHeadphoneIdentifier? {
        switch state.value {
        case .disconnected:
            // Return nil if no headphone is currently connected.
            return nil
        case .connected(let model):
            // If headphone connected, return the headphone identifier based on the headphone model value.
            return MimiHeadphoneIdentifier(model: model)
        }
    }

    /// Simulate headphone connection by setting the state to `connected` with mocked headphone model
    func simulateHeadphoneConnection() {
        let model = "mimi-partner-headphone-model"

        state.send(.connected(model: model))
    }
}

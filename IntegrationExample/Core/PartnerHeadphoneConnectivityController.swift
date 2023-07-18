//
//  PartnerHeadphoneConnectivityController.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 18.07.23.
//

import Foundation
import MimiCoreKit

/// A mock headphone connectivity controller which provides information on the currently connected headphone to the MSDK.
/// Documentation: https://mimihearingtechnologies.github.io/SDKDocs-iOS/master/connected-headphone-identification.html
final class PartnerHeadphoneConnectivityController: MimiConnectedHeadphoneProvider {
    
    enum ConnectivityState {
        case disconnected
        case connected(model: String)
    }
    
    var state: ConnectivityState = .connected(model: "mimi-partner-headphone-model") // Mock headphone model value.
    
    func getMimiHeadphoneIdentifier() -> MimiHeadphoneIdentifier? {
        
        switch state {
        case .disconnected:
            // Return nil if no headphone is currently connected.
            return nil
        case .connected(let model):
            // If headphone connected, return the headphone identifier based on the headphone model value.
            return MimiHeadphoneIdentifier(model: model)
        }
    }
}

//
//  HeadphoneConnectivityViewModel.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 10.05.24.
//

import Foundation
import Combine

final class HeadphoneConnectivityViewModel: ObservableObject {

    @Published var isHeadphoneConnected: Bool = false

    private let headphoneConnectivity: PartnerHeadphoneConnectivityController
    private var cancellables = Set<AnyCancellable>()

    init(headphoneConnectivity: PartnerHeadphoneConnectivityController) {
        self.headphoneConnectivity = headphoneConnectivity
        
        subscribeToHeadphoneConnectivityState()
    }

    private func subscribeToHeadphoneConnectivityState() {
        headphoneConnectivity.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] connectivityState in
                switch connectivityState {
                case .disconnected:
                    self?.isHeadphoneConnected = false
                case .connected:
                    self?.isHeadphoneConnected = true
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Headpone connectivity

    func simulateHeadphoneConnection(isConnected: Bool) {
        headphoneConnectivity.simulateHeadphoneConnection(isConnected: isConnected)
    }
}

//
//  TestViewModel.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 30.03.23.
//

import Foundation
import MimiCoreKit

final class TestViewModel: ObservableObject {
    
    @Published var latestMTHearingGrade = "-"
    @Published var latestPTTHearingGrade = "-"
    
    private let testController: MimiTestController
    
    init(testController: MimiTestController) {
        self.testController = testController
        
        testController.observable.addObserver(self)
        
        latestMTHearingGrade = makeLatestMTHearingGrade(from: testController.latestResults)
        latestPTTHearingGrade = makeLatestPTTHearingGrade(from: testController.latestResults)
    }
    
    private func makeLatestMTHearingGrade(from results: MimiTestResults?) -> String {
        guard let mtResults = results?.mt else {
            return "-"
        }
        
        return mtResults.hearingGrade.debugDescription
    }
    
    private func makeLatestPTTHearingGrade(from results: MimiTestResults?) -> String {
        guard let pttResults = results?.ptt else {
            return "-"
        }
        
        return pttResults.hearingGrade.debugDescription
    }
}

extension TestViewModel: MimiTestControllerObservable {
    
    func testController(_ controller: MimiTestController, didUpdate latestResults: MimiTestResults) {
        latestMTHearingGrade = makeLatestMTHearingGrade(from: testController.latestResults)
        latestPTTHearingGrade = makeLatestPTTHearingGrade(from: testController.latestResults)
    }
}

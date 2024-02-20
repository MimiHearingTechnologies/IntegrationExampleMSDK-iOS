//
//  DebouncedSlider.swift
//  IntegrationExample
//
//  Created by Salar on 2/19/24.
//

import SwiftUI
import Combine

/// A slider that debounces the user input values. Default debounce interval of 100ms.
struct DebouncedSlider<Label, ValueLabel> : View where Label : View, ValueLabel : View {
    
    @Binding var value: Float
    @StateObject private var viewModel: DebouncedSliderViewModel
    
    private var labelView: Label
    private var minimumValueLabelView: ValueLabel
    private var maximumValueLabelView: ValueLabel
    
    init(value: Binding<Float>, debounceInterval: Double = 0.1, @ViewBuilder label: () -> Label, @ViewBuilder minimumValueLabel: () -> ValueLabel, @ViewBuilder maximumValueLabel: () -> ValueLabel) {
        self._value = value
        _viewModel = StateObject(wrappedValue: DebouncedSliderViewModel(value: value.wrappedValue, debounceInterval: debounceInterval))
        labelView = label()
        minimumValueLabelView = minimumValueLabel()
        maximumValueLabelView = maximumValueLabel()
    }
    var body: some View {
        Slider(value: $viewModel.value) {
            labelView
        } minimumValueLabel: {
            minimumValueLabelView
        } maximumValueLabel: {
            maximumValueLabelView
        }
        .onReceive(viewModel.$debouncedValue) { (val) in
            value = val
        }
        .onAppear(perform: {
            viewModel.value = value
        })
    }
}

extension DebouncedSlider {
    
    private class DebouncedSliderViewModel : ObservableObject {
        @Published var debouncedValue: Float
        @Published var value: Float
        
        init(value: Float, debounceInterval: Double) {
            self.value = value
            debouncedValue = value
            $value
                .debounce(for: .seconds(debounceInterval), scheduler: DispatchQueue.main)
                .assign(to: &$debouncedValue)
        }
    }
}

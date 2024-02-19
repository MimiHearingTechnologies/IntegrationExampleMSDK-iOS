//
//  DebounceSliderView.swift
//  IntegrationExample
//
//  Created by Salar on 2/19/24.
//

import SwiftUI
import Combine

struct DebounceSliderView<Label, ValueLabel> : View where Label : View, ValueLabel : View {
    private class DebounceSliderViewModel : ObservableObject {
        @Published var debouncedValue: Float
        @Published var value: Float
        
        init(value: Float, debounce: Double) {
            self.value = value
            debouncedValue = value
            $value
                .debounce(for: .seconds(debounce), scheduler: DispatchQueue.main)
                .assign(to: &$debouncedValue)
        }
    }
    
    @Binding var value: Float
    @StateObject private var viewModel: DebounceSliderViewModel
    
    private var labelView: Label
    private var minimumValueLabelView: ValueLabel
    private var maximumValueLabelView: ValueLabel
    
    init(value: Binding<Float>, debounce: Double = 0.1, @ViewBuilder label: () -> Label, @ViewBuilder minimumValueLabel: () -> ValueLabel, @ViewBuilder maximumValueLabel: () -> ValueLabel) {
        self._value = value
        _viewModel = StateObject(wrappedValue: DebounceSliderViewModel(value: value.wrappedValue, debounce: debounce))
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

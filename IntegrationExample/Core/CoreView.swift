//
//  CoreView.swift
//  IntegrationExample
//
//  Created by Hozefa Indorewala on 30.03.23.
//

import SwiftUI

struct CoreView: View {
    var body: some View {
        List {
            Section(header: Text("Test")) {
                TestView()
            }
        }
    }
}

struct CoreView_Previews: PreviewProvider {
    static var previews: some View {
        CoreView()
    }
}

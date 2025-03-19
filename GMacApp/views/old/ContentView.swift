//
//  ContentView.swift
//  GMacApp
//
//  Created by Robert Talianu
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .frame(width: 100, height: 100)
            Text("Hello, world 2!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

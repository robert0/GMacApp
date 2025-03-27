//
//  LogWg.swift
//  GApp
//
//  Created by Robert Talianu
//
import SwiftUI
		
struct LogView: View {
    @ObservedObject var viewModel = LogViewModel()
    @Namespace var bottomID

    // The logs panel
    var body: some View {
        
        ScrollView {
            ScrollViewReader { value in
                     
                VStack(alignment: HorizontalAlignment.leading) {
                    Text("--- Logging (Trimmed) ---")
                    Spacer()
                    
                    Text(viewModel.text)
                        .lineLimit(nil)
                        .textSelection(.enabled)
                    
                    Text("").id(bottomID)
                    
                }.onChange(of: viewModel.text.count) { _ in
                    value.scrollTo(bottomID)
                }
                
//                ForEach(0..<entries.count) { i in
//                    Text(self.entries[i].getName())
//                        .frame(width: 300, height: 200)
//                        .background(colors[i % colors.count])
//                        .padding(.all, 20)
//                }
//                .onChange(of: entries.count) { _ in
//                    value.scrollTo(entries.count - 1)
//                }
            }
        }.frame(maxWidth: 600)
            .border(Color.red)
        
//        ScrollView() {
//            VStack(alignment: HorizontalAlignment.leading) {
//                Text("--- Logging (Trimmed) ---")
//                Spacer()
//                Text(viewModel.text)
//                    .lineLimit(nil)
//                    .textSelection(.enabled)
//            }
//        }.frame(maxWidth: 600)
//            .border(Color.red)
        
    }
    
    // The logs panel
    func logCallbackFunction(_ message:String) {
        self.viewModel.text = message
    }
}

final class LogViewModel: ObservableObject {
    @Published var text = "UI Logging Initialized..."
}

import CoreMotion
//
//  AppTabView.swift
//  GApp
//
//  Created by Robert Talianu
//
import SwiftUI

struct AppTabView: View {
    var inGesturesStore:InGestureStore
    @State var inGCount:Int = 0
    @State var selection: Int? = 1
    
    // constructor
    init() {
        //initilize app vars
        self.inGesturesStore = InGestureStore()
    }
    
    // The app panel
    var body: some View {
        //add buttons
        NavigationStack {
            VStack (alignment: .leading) {
                Spacer().frame(height:30)
                
                //
                // Incomming Gestures View
                //
                NavigationLink(destination: IncommingGesturesView(inGesturesStore)) {
                    Image(systemName: "iphone.and.arrow.right.inward")
                        .imageScale(.large)
                    Text("Gestures Mapping( \(inGCount) )")
                }
                Spacer().frame(height:30)
                
                //
                // Bluetooth View
                //
                if(GMacAppApp.btPeripheralDevice == nil){
                    NavigationLink(destination:  BTView()) {
                        Image(systemName: "iphone.gen1.and.arrow.left")
                            .imageScale(.large)
                        Text("Configure Bluetooth...")
                    }
                   
                } else {
                    NavigationLink(destination:  BTView()) {
                        Image(systemName: "link")
                            .imageScale(.large)
                        Text("Paired to \(GMacAppApp.btPeripheralDevice?.name ?? "Unknown")")
                    }
               }
                Spacer().frame(height:30)
                
                //
                // About View
                //
                NavigationLink(destination: About()) {
                    Image(systemName: "iphone.and.arrow.right.inward")
                        .imageScale(.large)
                    Text("About")
                }
                Spacer().frame(height:30)
                Spacer()
            }
        }
    }

}

//
//  ContentView.swift
//  GApp
//
//  Created by Robert Talianu 
//

import SwiftUI

struct AppRootView: View {
    //logger view wg
    private var logView: LogView
    
    init () {
        //initilize local vars
        self.logView = LogView()
        Globals.setChangeCallback(self.logView.logCallbackFunction)
    }
    
    var body: some View {
      
        TabView{
            let av = AppTabView()
            av.tabItem {
                Text("App")
            }.tag(1)

            logView.tabItem {
                Text("Logs")
            }.tag(2)
           

            let btv = BTView()
            btv.tabItem {
                Text("Bluetooth")
            }.tag(3)
        }

    }



}

#Preview {
    AppRootView()
}

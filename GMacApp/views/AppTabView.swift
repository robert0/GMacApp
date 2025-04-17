//
//  AppTabView.swift
//  GApp
//
//  Created by Robert Talianu
//
import SwiftUI
import CoreMotion
import CoreBluetooth

struct AppTabView: View {
    var inGesturesStore:InGestureStore
    @State var inGCount:Int = 0
    @State var selection: Int? = 1
    @State var btDevice:CBPeripheral?
    @State var isOn = true
    @State var cmdTxt:String = "Command Forwarding (Enabled)"
    
    // constructor
    init() {
        //initilize app vars
        self.inGesturesStore = GMacAppApp.getGestureDispatcher().getInGestureStore()!//expecting by this time to be already created
    }
    
    // The app panel
    var body: some View {
        HStack {
            Spacer().frame(width: 30)
            //add buttons
            NavigationStack {
                VStack (alignment: .leading) {
                    Spacer().frame(height:30)
                    
                    Toggle(isOn: $isOn) {
                        Text("\(cmdTxt)")
                    }.foregroundColor(.blue)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .onChange(of: isOn) { state in
                            print("toggled to \(state)")
                            cmdTxt = "Command Forwarding (\(state ? "Enabled" : "Disabled"))"
                            if(state){
                                GMacAppApp.enableCommandForwarding()
                            } else {
                                GMacAppApp.disableCommandForwarding()
                            }
                        }
                    Spacer().frame(height:15)
                    Text(" Enabling Command Fowarding will make the app execute the default gestures commands, even if there is no mapping defined for them. In case there is a mapping, the command from mapping will be executed.\n When this flag is disabled, the app will execute only commands for gestures that have mapping (commands defined by the mapping)").italic()
                    Spacer().frame(height:30)
                    //
                    // Incomming Gestures View
                    //
                    NavigationLink(destination: IncommingGesturesView(self.inGesturesStore)) {
                        Image(systemName: "iphone.and.arrow.right.inward")
                            .imageScale(.large)
                        Text("Gestures Mapping( \(inGCount) )")
                    }
                    Spacer().frame(height:30)
                    
                    //
                    // Bluetooth View
                    //
                    if(btDevice == nil){
                        NavigationLink(destination:  BTView()) {
                            Image(systemName: "iphone.gen1.and.arrow.left")
                                .imageScale(.large)
                            Text("Configure Bluetooth...")
                        }
                        
                    } else {
                        NavigationLink(destination:  BTView()) {
                            Image(systemName: "link")
                                .imageScale(.large)
                            Text("Paired to \(btDevice?.name ?? "Unknown")")
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
                    
                    Button("Execute Cmd") {
                        Globals.log("Execute Cmd clicked...")
                        //CommandExecutor.shell("ls")
                        //CommandExecutor.shell("cd /Users/roberttalianu/Desktop; pwd; osascript Keynote_start_presentation.scpt")
                        
                        //CommandExecutor.shell("open https://www.google.com")
                        //CommandExecutor.executeCommand("cd /Users/roberttalianu/Desktop; ls")
                        
                        
                        //var script = AppleScriptRunner("display dialog \"Hello World\"")
                        //var script = AppleScriptRunner("tell application \"Safari\" to activate")
                        var script = AppleScriptRunner("""
                            if running of application \"Keynote\" is true then
                                    tell application \"Keynote\"
                                    activate
                                    try
                                        if playing is false then start the front document
                                    end try
                                end tell
                            end if
                            """)
                            
                        script.executeAsync()
                        
//                        """
//                        tell application "Safari"
//                            get url of tabs of windows
//                        end
//                        """
                        
                    }.buttonStyle(.borderedProminent)
                    Spacer().frame(width: 10)
                    
                    Spacer()
                    
                }
            }.onAppear(){
                Globals.log("AppTabView onAppear...")
                inGCount = self.inGesturesStore.getAllGestures().count
                btDevice = GMacAppApp.btPeripheralDevice
                
            }
            Spacer().frame(width: 30)
        }
    }
}

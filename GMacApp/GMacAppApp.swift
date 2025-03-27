//
//  GMacAppApp.swift
//  GMacApp
//
//  Created by Robert Talianu
//

import SwiftUI
import CoreBluetooth

@main
struct GMacAppApp: App {
    static var isCommandForwarding:Bool = true
    static var gestureDispatcher:GestureDispatcher = GestureDispatcher()
    static var btInInstance:BTCentralObj_IN?
    static var btPeripheralDevice:CBPeripheral?
    
    static var rootView:AppRootView?
    
    init(){
        Globals.log("App: Initializing main class")
        //initialize the InGestureStore
        GMacAppApp.gestureDispatcher.setInGestureStore(InGestureStore())
        
        //load saved gestures mappings from filesystem
        let igestures = FileSystem.readIncommingGesturesMappingDataFile()
        Globals.log("App: Loaded incomming gestures mapping count: \(igestures.count)")
        if igestures.count > 0 {
            igestures.forEach({
                GMacAppApp.gestureDispatcher.getInGestureStore()!.setGestureMapping($0.getName(), $0)
            })
        }
        
        GMacAppApp.rootView = AppRootView()
    }
    
    var body: some Scene {
        WindowGroup {
            GMacAppApp.rootView
        }
    }
    
    ///
    ///
    ///
    public static func enableCommandForwarding(){
        isCommandForwarding = true
    }
    
    ///
    ///
    ///
    public static func disableCommandForwarding(){
        isCommandForwarding = false
    }
    
    /*
     *
     */
    public static func startBTInbound() -> BTCentralObj_IN? {
        Globals.log("App: startBTInbound() called..")
        if(GMacAppApp.btInInstance == nil){
            GMacAppApp.btInInstance = BTCentralObj_IN()//self start scanning
            GMacAppApp.btInInstance?.addBTChangeListener(gestureDispatcher)
        }
        return GMacAppApp.btInInstance
    }
    
    /**
     *
     */
    public static func addBTChangeListener(_ btl:BTChangeListener) {
        if(GMacAppApp.btInInstance != nil){
            GMacAppApp.btInInstance!.addBTChangeListener(btl)
            
        } else {
            Globals.log("App: addBTChangeListener failed; No btInInstance")
        }
    }
    
    /**
     *
     */
    public static func getGestureDispatcher() -> GestureDispatcher {
        return GMacAppApp.gestureDispatcher
    }
    
    
    /*
     *
     */
    public static func startBTScanning() {
        //Globals.log("APP_Main:startBTScanning() called..")
        if(GMacAppApp.btInInstance != nil){
            GMacAppApp.btInInstance!.startScan()
            
        } else {
            Globals.log("App: startBTScanning failed; No btInInstance")
        }
    }
    
    /*
     *
     */
    public static func stopBTScanning() {
        //Globals.log("APP_Main:stopBTScanning() called..")
        if(GMacAppApp.btInInstance != nil){
            GMacAppApp.btInInstance!.stopScanning()
            
        } else {
            Globals.log("App: stopBTScanning failed; No btInInstance")
        }
    }
    
    /*
     *
     */
    public static func connectToBTDevice(_ cbp:CBPeripheral) {
        Globals.log("App: connectToBTDevice() called..")
        
        //store locally
        GMacAppApp.btPeripheralDevice = cbp
        
        //connecting to a peripheral will automatically stop the current scanning
        GMacAppApp.btInInstance?.connectToPeripheral(cbp)
        
    }
}

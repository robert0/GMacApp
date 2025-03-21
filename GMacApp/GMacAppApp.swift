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
    static var gestureDispatcher:GestureDispatcher = GestureDispatcher()
    static var btInInstance:BTCentralObj_IN?
    static var btPeripheralDevice:CBPeripheral?
    
    init(){
        //initialize the InGestureStore
        GMacAppApp.gestureDispatcher.setInGestureStore(InGestureStore())
    }
    
    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
    }
    
    /*
     *
     */
    public static func startBTInbound() -> BTCentralObj_IN? {
        Globals.log("APP_Main:startBT() called..")
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
            Globals.log("APP_Main:addBTChangeListener failed; No btInInstance")
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
            Globals.log("APP_Main:startBTScanning failed; No btInInstance")
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
            Globals.log("APP_Main:stopBTScanning failed; No btInInstance")
        }
    }
    
    /*
     *
     */
    public static func connectToBTDevice(_ cbp:CBPeripheral) {
        Globals.log("APP_Main:connectToBTDevice() called..")
        
        //store locally
        GMacAppApp.btPeripheralDevice = cbp
        
        //connecting to a peripheral will automatically stop the current scanning
        GMacAppApp.btInInstance?.connectToPeripheral(cbp)
        
    }
}

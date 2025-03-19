//
//  GestureDispatcher.swift
//  GApp2
//
//  Created by Robert Talianu
//

import Foundation
import CoreBluetooth

//
// This class handles the realtime gesture dispatching once a gesture is found
//
public class GestureDispatcher : BTChangeListener {

    private let correlationFactorFormat: String = " %.3f"//add space first for good JSON formatting
       var inGesturesStore:InGestureStore?
    

    public init (){
    }
    
    
    public func setInGestureStore(_ inGesturesStore:InGestureStore){
        self.inGesturesStore = inGesturesStore
    }
       
        
    public func onManagerDataChange(_ central: CBCentralManager) {
        Globals.log("GestureDispatcher:onManagerDataChange called...")
        //not used
    }
    
    public func onPeripheralChange(_ central: CBCentralManager, _ peripheral: CBPeripheral) {
        Globals.log("GestureDispatcher:onPeripheralChange called...")
        //not used
    }
    
    public func onPeripheralDataChange(_ central: CBCentralManager, _ peripheral: CBPeripheral, _ characteristic: CBCharacteristic) {
        Globals.log("GestureDispatcher:onPeripheralDataChange called...")
        let value = characteristic.value ?? Data()
        let message = String(data: value, encoding: .utf8)
        Globals.log("BT Received message: \(message)")
    }
    
    
}

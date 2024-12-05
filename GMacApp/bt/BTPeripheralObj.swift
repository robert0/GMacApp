//
//  BTPeripheralObj.swift
//  GApp
//
//  Created by Robert Talianu
//
import CoreBluetooth
import OrderedCollections

class BTPeripheralObj: NSObject, CBPeripheralManagerDelegate {
    
    
    // Properties
    var peripheralManager: CBPeripheralManager!
    
    let serviceUUID = CBUUID(string: "0000FFF0-0000-1000-2000-300040005000")
    let characteristicUUID = CBUUID(string: "0000FFF0-0000-1000-2000-300040005001")
    var characteristic: CBMutableCharacteristic?
    
    private var mDataChangeListener: BTChangeListener?
    
    override init() {
        super.init()
        Globals.logToScreen("Starting CBPeripheralManager...")
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    /**
     * @param dataChangeListener
     */
    public func setChangeListener(_ dataChangeListener: BTChangeListener) {
        mDataChangeListener = dataChangeListener
    }
    
    //called when Peripheral Manager State changes
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            Globals.logToScreen("BT Peripheral is ON. Creating service and characteristic...")
            //when CBPeripheralManager is ON, add new service/characteristic that will be used for communication
            let characteristic = CBMutableCharacteristic(type: characteristicUUID, properties: [.notify, .read, .write], value: nil, permissions: [.readable, .writeable])
            let service = CBMutableService(type: serviceUUID, primary: true)
            service.characteristics = [characteristic]
            peripheralManager.add(service)
            self.characteristic = characteristic
            
            Globals.logToScreen("BT Start Advertising...")
            peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [serviceUUID]])
        } else {
            print("Peripheral is not available.")
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        if request.characteristic.uuid == characteristicUUID {
            if let value = "Hello Central".data(using: .utf8) {
                request.value = value
                peripheralManager.respond(to: request, withResult: .success)
            }
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            if request.characteristic.uuid == characteristicUUID {
                if let value = request.value, let message = String(data: value, encoding: .utf8) {
                    print("Received message: \(message)")
                }
                peripheralManager.respond(to: request, withResult: .success)
            }
        }
    }
    
}

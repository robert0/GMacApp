//
//  BTCentralObj.swift
//  GApp
//
//  Created by Robert Talianu
//
import CoreBluetooth
import OrderedCollections

class BTCentralObj: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    
    let serviceUUID = CBUUID(string: "0000FFF0-0000-1000-2000-300040005000")
    let characteristicUUID = CBUUID(string: "0000FFF0-0000-1000-2000-300040005001")
    var characteristic: CBMutableCharacteristic?
    var discoveredPeripheral: CBPeripheral?
    
    private var peripheralsMap = OrderedDictionary<String, CBPeripheral>()
    
    private var mDataChangeListener: BTChangeListener?
    
    override init() {
        super.init()
        Globals.logToScreen("BT Starting CBCentralManager...")
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    /**
     * @param dataChangeListener
     */
    public func setChangeListener(_ dataChangeListener: BTChangeListener) {
        mDataChangeListener = dataChangeListener
    }
    
    /**
     *
     */
    func getPeripheralMap() -> OrderedDictionary<String, CBPeripheral> {
        return peripheralsMap
    }
    
    // Start Scanning
    func startScan() {
        Globals.logToScreen("Start Scanning ...")
        peripheralsMap.removeAll()
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    /**
     * Connect to the provided peripheral...
     */
    public func connectToPeripheral(_ peripheral: CBPeripheral) {
        Globals.logToScreen("BT Connecting to peripheral: " + (peripheral.name ?? "unknown") + " " + peripheral.identifier.uuidString)
        //stop scanning first
        self.centralManager.stopScan()

        discoveredPeripheral = peripheral
        discoveredPeripheral!.delegate = self
        self.centralManager.connect(peripheral, options: nil)
    }
    
    //-------------------------------------------------------------------------
    //------------------------- CBCentralManagerDelegate ----------------------
    //-------------------------------------------------------------------------
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            Globals.logToScreen("Bluetooth is ON. Waiting for commands...")
            //centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
        } else {
            print("Bluetooth is not available.")
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        Globals.logToScreen("BT Found peripheral: " + (peripheral.name ?? "no-name, ") + peripheral.identifier.uuidString)

        //add peripheral to the map
        peripheralsMap[peripheral.identifier.uuidString] = peripheral

        mDataChangeListener?.onPeripheralChange(central, peripheral)
    }
    
   
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        Globals.logToScreen("BT Peripheral connected, discovering services...")
        peripheral.delegate = self
        peripheral.discoverServices([serviceUUID])
    }
    
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("BT Disconnected from peripheral")
    }
    
    //-------------------------------------------------------------------------
    //------------------------- CBPeripheralDelegate --------------------------
    //-------------------------------------------------------------------------
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        Globals.logToScreen("BT Services discovered, discovering characteristics...")
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics([characteristicUUID], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == characteristicUUID {
                    Globals.logToScreen("BT found the right characteristic, setting notification flag ON...")
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == characteristicUUID {
            Globals.logToScreen("BT Characteristic update, reading message...")
            if let value = characteristic.value, let message = String(data: value, encoding: .utf8) {
                Globals.logToScreen("BT Received message: \(message)")
                mDataChangeListener?.onPeripheralDataChange(centralManager, peripheral, characteristic.value)
            }
        }
    }

}

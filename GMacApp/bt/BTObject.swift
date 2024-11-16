//
//  ViewController.swift
//  GApp
//
//  Created by Robert Talianu
//
import CoreBluetooth
import OrderedCollections


class BTObject: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate {
    // Properties
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    private let SERVICE_UUID = CBUUID(string: "8c2a81f7-f8b8-4b31-89b4-6b5d98a822db")
    private let CHARACTERISTIC_UUID = CBUUID(string: "e8bd8c82-2506-4fae-b5f2-9bbbf4ab5b0e")
    
    private var peripheralsMap = OrderedDictionary<String, CBPeripheral>()
    private var mDataChangeListener: BTChangeListener?

    override init() {
        super.init()
        Globals.logToScreen("Starting CBCentralManager...")
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

    // Called when BT changes state
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        Globals.logToScreen("Central state update:" + String(central.state.rawValue))
        
        mDataChangeListener?.onManagerDataChange(central)
        
        switch central.state {
        case CBManagerState.poweredOn:
            // Notify user Bluetooth in ON
            Globals.logToScreen("Central: Bluetooth is ON")
            break
        case CBManagerState.poweredOff:
            // Alert user to turn on Bluetooth
            Globals.logToScreen("Central: Bluetooth is OFF")
            break
        case CBManagerState.resetting:
            // Wait for next state update and consider logging interruption of Bluetooth service
            Globals.logToScreen("Central: Bluetooth is RESETTING")
            break
        case CBManagerState.unauthorized:
            // Alert user to enable Bluetooth permission in app Settings
            Globals.logToScreen("Central: Bluetooth is UNAUTHORIZED; Check for access permissions ( info.plist )")
            break
        case CBManagerState.unsupported:
            // Alert user their device does not support Bluetooth and app will not work as expected
            Globals.logToScreen("Central: Bluetooth is UNSUPPORTED; Check for access permissions ( info.plist )")
            break
        case CBManagerState.unknown:
            // Wait for next state update
            Globals.logToScreen("Central: Bluetooth is UNKNOWN; Check for access permissions ( info.plist )")
            break
        default:
            Globals.logToScreen("Central: Bluetooth is ---")
            break
        }
    }

    // Start Scanning
    func startScan() {
        Globals.logToScreen("Start Scanning ...")
        peripheralsMap.removeAll()
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }

    // Handles the result of the scan
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        Globals.logToScreen("Scan update ...")
        Globals.logToScreen("Found peripheral: " + (peripheral.name ?? "no-name, ") + peripheral.identifier.uuidString)

        //add peripheral to the map
        peripheralsMap[peripheral.identifier.uuidString] = peripheral

        mDataChangeListener?.onPeripheralChange(central, peripheral)
    }

    /**
     * Connect to the provided peripheral...
     */
    public func connectToPeripheral(_ peripheral: CBPeripheral) {
        Globals.logToScreen("Connecting to peripheral: " + (peripheral.name ?? "unknown") + " " + peripheral.identifier.uuidString)
        //stop scanning first
        self.centralManager.stopScan()

        self.peripheral = peripheral
        self.peripheral.delegate = self
        self.centralManager.connect(peripheral, options: nil)
    }

    // retry if error when connecting to peripheral
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        Globals.logToScreen("Failed to connect, retrying...")
        centralManager.connect(peripheral, options: nil)
    }

    // The handler if we do connect succesfully
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        Globals.logToScreen("Peripheral connected ...")
        if peripheral == self.peripheral {
            Globals.logToScreen("Discovering services...")
            peripheral.discoverServices(nil)
        }
    }

    // Handles services discovery event
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        Globals.logToScreen("-ss- peripheral services:" + (error?.localizedDescription ?? "(no-error)"))
        if let services = peripheral.services {
            for service in services {
                Globals.logToScreen("-s--- service found: \(service.uuid.uuidString) \(service.description)")
                //Now start discovery of characteristics
                Globals.logToScreen("Discovering service characteristics...")
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }

    // Handling discovery of characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        Globals.logToScreen("-cc- serivice characteristics:" + (error?.localizedDescription ?? "(no-error)"))
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                Globals.logToScreen("---c- characteristic found: \(characteristic.uuid.uuidString) \(characteristic.description)")
            }
        }
    }
    
    
    func sendText(_ text: String) {
        guard let peripheral = self.peripheral,
              let characteristic = peripheral.services?.first?.characteristics?.first(where: { $0.uuid == CHARACTERISTIC_UUID })
        else {
            print("Peripheral or characteristic not found")
            return
        }
        
        print("Sending: \(text)")
        let data = text.data(using: .utf8)!
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
}

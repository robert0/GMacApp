//
//  BTView.swift
//  GApp
//
//  Created by Robert Talianu
//
import SwiftUI
import CoreBluetooth

struct BTView: View, BTChangeListener {
    @ObservedObject var viewModel = BTViewModel()
    //@State var $selected: String?
    @State private var selection: String?
    
    // The bluetooth panel
    var body: some View {
        return VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.gray)
            //Text("BT State: \(viewModel.updateCounter)")
            Button("Press to Scan for Bluetooth Devices", action: startBTFn)
            var entries = viewModel.bto?.getPeripheralMap() ?? [:]
            if !entries.isEmpty {
                VStack {
                    Text("Scanning...")
                    List(selection: $selection) {
                        ForEach(entries.elements, id: \.key) { key, value in
                            if(value.name != nil) {//allow only named BTs
                                Text(value.name!)
                            }
                        }
                        .padding(.bottom)
                    }
                    .frame(width: nil, height: 300)
                    .background(Color.white)
                    
                    Button("Connect", action: connectBT)
                        .disabled(selection == nil)
                }.background(Color.white).padding(20)
            }
        }
    }
    
    func startBTFn() {
        Globals.logToScreen("StartBTFn called..")
        viewModel.bto!.startScan()
    }
    
    func connectBT() {
        Globals.logToScreen("ConnectBT called.." + (selection ?? ""))
        if selection != nil {
            var peripheral = viewModel.bto!.getPeripheralMap()[selection!]
            if peripheral != nil {
                viewModel.bto!.connectToPeripheral(peripheral!)
            }
        }
    }
    
    init() {
        viewModel.bto = BTObject()
        viewModel.bto!.setChangeListener(self)
    }
    
    /**
     * @param btMgr
     *
     */
    func onManagerDataChange(_ btMgr: CBCentralManager) {
        Globals.logToScreen("BTView onManagerDataChange called..")
        viewModel.btMgr = btMgr
        viewModel.updateCounter += 1
    }
    
    /**
     * @param btMgr
     * @param peripheral
     */
    func onPeripheralChange(_ btMgr: CBCentralManager, _ peripheral: CBPeripheral) {
        Globals.logToScreen("BTView onPeripheralChange called..")
        viewModel.updateCounter += 1
    }
    
    /**
     * @param btMgr
     */
    func onPeripheralDataChange() {
        Globals.logToScreen("BTView onPeripheralDataChange called..")
    }
    
}

//
// Helper class for DataView that handles the updates
//
// Created by Robert Talianu
//
final class BTViewModel: ObservableObject {
    @Published var updateCounter: Int = 1
    @Published var bto: BTObject?
    @Published var btMgr: CBCentralManager?
    @Published var selection: String?
    
}

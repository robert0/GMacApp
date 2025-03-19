//
//  BTView.swift
//  GApp
//
//  Created by Robert Talianu
//
import SwiftUI
import CoreBluetooth

//struct BTView_old: View, BTChangeListener {
//
//    @ObservedObject var viewModel = BTOldViewModel()
//    //@State var $selected: String?
//    @State private var selection: String?
//    
//    // The bluetooth panel
//    var body: some View {
//        return VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.gray)
//            //Text("BT State: \(viewModel.updateCounter)")
//            Button("Execute Command", action: executeCmd)
//            Button("Press to Scan for Bluetooth Devices", action: startBTFn)
//            var entries = viewModel.bto?.getPeripheralMap() ?? [:]
//            if !entries.isEmpty {
//                VStack {
//                    Text("Scanning...")
//                    List(selection: $selection) {
//                        ForEach(entries.elements, id: \.key) { key, value in
//                            if(value.name != nil) {//allow only named BTs
//                                Text(value.name!)
//                            }
//                        }
//                        .padding(.bottom)
//                    }
//                    .frame(width: nil, height: 300)
//                    .background(Color.white)
//                    
//                    Button("Connect", action: connectBT)
//                        .disabled(selection == nil)
//                }.background(Color.white).padding(20)
//            }
//        }
//    }
//    
//    func executeCmd() {
//        Globals.logToScreen("executeCmd called..")
//        //CommandExecutor().shell("open \"https://www.google.com\"")
//        //let json = "{\"gestureKey\":\"A\", \"gestureCorrelationFactor\":\"0,41\"}"
//        //var data = convertJsonToDictionary(json) ?? [:]
//        
//        var xx = "{\"gestureKey\":\"KEY\",\"gestureCorrelationFactor\": 0.123}"
//        let gobj1: GestureJson? = decodeDataToObject(data: xx.data(using: .utf8)!)
//     
//        
//        //var xd:String = data["gestureCorrelationFactor"] as! String
//        Globals.logToScreen("executeCmd called.." + gobj1.debugDescription)
//    }
//    
//    //
//    func convertJsonToDictionary(_ text: String) -> [String: Any]? {
//        if let data = text.data(using: .utf8) {
//            do {
//                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        return nil
//    }
//       
//    func startBTFn() {
//        Globals.logToScreen("StartBTFn called..")
//        viewModel.bto!.startScan()
//    }
//    
//    func connectBT() {
//        Globals.logToScreen("ConnectBT called.." + (selection ?? ""))
//        if selection != nil {
//            let peripheral = viewModel.bto!.getPeripheralMap()[selection!]
//            if peripheral != nil {
//                viewModel.bto!.connectToPeripheral(peripheral!)
//            }
//        }
//    }
//    
//    init() {
//        viewModel.bto = BTCentralObj_IN()
//        viewModel.bto!.addBTChangeListener(self)
//    }
//    
//    /**
//     * @param btMgr
//     *
//     */
//    func onManagerDataChange(_ btMgr: CBCentralManager) {
//        Globals.logToScreen("BTView onManagerDataChange called..")
//        viewModel.btMgr = btMgr
//        viewModel.updateCounter += 1
//    }
//    
//    /**
//     * @param btMgr
//     * @param peripheral
//     */
//    func onPeripheralChange(_ btMgr: CBCentralManager, _ peripheral: CBPeripheral) {
//        Globals.logToScreen("BTView onPeripheralChange called..")
//        viewModel.updateCounter += 1
//    }
//    
//    /**
//     * @param btMgr
//     * @param peripheral
//     * @param data
//     */
//    func onPeripheralDataChange(_ central: CBCentralManager, _ peripheral: CBPeripheral, _ cb: CBCharacteristic?){
//        Globals.logToScreen("BTView onPeripheralDataChange called..")
//        
//        let data = cb?.value
//        
//        var xx = "{\"gestureKey\":\"KEY\",\"gestureCorrelationFactor\": -12.123}"
//        let gobj1: GestureJson? = decodeDataToObject(data: xx.data(using: .utf8)!)
//        Globals.logToScreen("BT JSON test data: \(gobj1!.gestureCorrelationFactor)")
//        
//        let gobj: GestureJson? = decodeDataToObject(data: data)
//        Globals.logToScreen("BT JSON Data: \(gobj?.gestureCorrelationFactor)")
//        
//        if(gobj?.gestureCorrelationFactor ?? 0.0 > 0.9){
//            Globals.logToScreen("BTView VALID gesture...")
//            executeCmd(gobj)
//        }
//    }
//    
//    /**
//     * @param gj
//     */
//    func executeCmd(_ gj:GestureJson?) {
//        Globals.logToScreen("BT executeCmd by gesture called..")
//        
//        if(gj?.gestureKey ?? "" == "A"){
//            Globals.logToScreen("BT executeCmd by gesture key >>>")
//            CommandExecutor().shell("open \"https://www.google.com\"")
//            
//        } else if(gj?.gestureKey ?? "" == "B"){
//            Globals.logToScreen("BT executeCmd by gesture key >>>")
//            CommandExecutor().shell("open \"https://www.yahoo.com\"")
//        }
//    }
//    
//    //decode data to json object
//    func decodeDataToObject<T: Codable>(data : Data?)->T?{
//        
//        if let dt = data{
//            do{
//                
//                return try JSONDecoder().decode(T.self, from: dt)
//                
//            }  catch let DecodingError.dataCorrupted(context) {
//                Globals.logToScreen("JSON " + context.debugDescription)
//                
//            } catch let DecodingError.keyNotFound(key, context) {
//                Globals.logToScreen("JSON - Key '\(key)' not found:" + context.debugDescription)
//                Globals.logToScreen("JSON - codingPath:" + context.codingPath.debugDescription)
//                
//            } catch let DecodingError.valueNotFound(value, context) {
//                Globals.logToScreen("JSON - Value '\(value)' not found:" + context.debugDescription)
//                Globals.logToScreen("JSON - codingPath:" + context.codingPath.debugDescription)
//                
//            } catch let DecodingError.typeMismatch(type, context)  {
//                Globals.logToScreen("JSON - Type '\(type)' mismatch:" + context.debugDescription)
//                Globals.logToScreen("JSON - codingPath:" + context.codingPath.debugDescription)
//                
//            } catch {
//                Globals.logToScreen("JSON - error: " + error.localizedDescription)
//            }
//        }
//        
//        return nil
//    }
//}

//
// Helper class for BTView_old that handles the updates
//
// Created by Robert Talianu
//
//final class BTOldViewModel: ObservableObject {
//    @Published var updateCounter: Int = 1
//    @Published var bto: BTCentralObj_IN?
//    @Published var btMgr: CBCentralManager?
//    @Published var selection: String?
//    
//}

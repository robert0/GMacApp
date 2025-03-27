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
    var inGesturesStore:InGestureStore?
    
    
    ///
    ///
    ///
    public func getInGestureStore() -> InGestureStore? {
        return self.inGesturesStore
    }
    
    ///
    ///
    ///
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
        let gobj: GestureJson? = decodeDataToObject(data: value)
        
        let message = String(data: value, encoding: .utf8)
        Globals.log("GestureDispatcher: ====== > received gesture: \(gobj?.gestureKey ?? "no valid gs") - \(gobj?.gestureCorrelationFactor)")
        
        if(gobj == nil ){
            Globals.log("GestureDispatcher: Error. Could not decode incomming gesture")
            return
        }
        
        let cmd = gobj!.gestureCommand
        var mpcmd = getMappedCommand(gobj!)
        if (mpcmd.isEmpty) {
            if(GMacAppApp.isCommandForwarding){
                Globals.log("GestureDispatcher: CommandForwarding is set, executing the default gesture command")
                callCommand(cmd)
            }
        } else {
            callCommand(mpcmd)
        }
    }
    
    /**
     *
     * Find mapping for incomming gesture and call the command associated with it
     *
     * @param gobj
     */
    private func getMappedCommand(_ gobj:GestureJson) -> String{
        Globals.log("GestureDispatcher: Info -> Trying to find mapped command for incomming gesture...")
        if(inGesturesStore == nil || inGesturesStore!.getKeys().count == 0){
            Globals.log("GestureDispatcher: Warning. No InGestureStore set or there is no entry in the InGestureStore")
            return ""
        }
            
        let gsm = inGesturesStore!.getFirstGestureMappingByIncommingKey(gobj.gestureKey)
        if(gsm == nil){
            Globals.log("GestureDispatcher: Warning. Could not find any gesture mapping for the received gesture")
            return ""
        }
        
        Globals.log("GestureDispatcher: Found mapping for incomming gesture \(gsm!.getName())")
        let cmd = gsm!.getCommand()
        if(cmd.isEmpty){
            Globals.log("GestureDispatcher: Warning. There is no command defined for the incomming gesture")
            return ""
        }
        
        return cmd
    }
    
    /**
     *
     * Do direct call of command that comes with the incomming gesture
     *
     * @param gobj
     */
    private func callCommand(_ cmd:String){
        if(cmd.isEmpty){
            Globals.log("GestureDispatcher: Warning. The command to be executed is empty, ignoring it...")
            return
        }
        
        Globals.log("GestureDispatcher: Executing command <\(cmd)>")
        CommandExecutor.shell(cmd)
    }
    
    
    /**
     *
     * Incomming message from a peripheral that is listened
     *
     * @param btMgr
     * @param peripheral
     * @param data
     */
    func onPeripheralDataChange(_ central: CBCentralManager, _ peripheral: CBPeripheral, _ data: Data?){
        Globals.log("BT: onPeripheralDataChange called..")
        
        //var xx = "{\"gestureKey\":\"KEY\",\"gestureCorrelationFactor\": -12.123}"
        //let gobj1: GestureJson? = decodeDataToObject(data: xx.data(using: .utf8)!)
        //Globals.logToScreen("BT JSON test data: \(gobj1!.gestureCorrelationFactor)")
        
        let gobj: GestureJson? = decodeDataToObject(data: data)
        Globals.log("BT JSON Data: \(gobj?.gestureCorrelationFactor)")
        
        if(gobj?.gestureCorrelationFactor ?? 0.0 > 0.9){
            Globals.log("BTView VALID gesture...")
            //executeCmd(gobj)
            
        }
    }
    
    //decode data to json object
    func decodeDataToObject<T: Codable>(data : Data?) -> T? {
        
        if let dt = data {
            do {
                
                return try JSONDecoder().decode(T.self, from: dt)
                
            }  catch let DecodingError.dataCorrupted(context) {
                Globals.logToScreen("JSON " + context.debugDescription)
                
            } catch let DecodingError.keyNotFound(key, context) {
                Globals.logToScreen("JSON - Key '\(key)' not found:" + context.debugDescription)
                Globals.logToScreen("JSON - codingPath:" + context.codingPath.debugDescription)
                
            } catch let DecodingError.valueNotFound(value, context) {
                Globals.logToScreen("JSON - Value '\(value)' not found:" + context.debugDescription)
                Globals.logToScreen("JSON - codingPath:" + context.codingPath.debugDescription)
                
            } catch let DecodingError.typeMismatch(type, context)  {
                Globals.logToScreen("JSON - Type '\(type)' mismatch:" + context.debugDescription)
                Globals.logToScreen("JSON - codingPath:" + context.codingPath.debugDescription)
                
            } catch {
                Globals.logToScreen("JSON - error: " + error.localizedDescription)
            }
        }
        
        return nil
    }
}

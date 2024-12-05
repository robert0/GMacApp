//
//  DataChangeListener.swift
//  GApp
//
//  Created by Robert Talianu
//

import CoreBluetooth


public protocol BTDataChangeListener {
       
    /**
     * @return
     */
    func onPeripheralDataChange(_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic,_ value: Data);
}

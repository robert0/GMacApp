//
//  FileSystem.swift
//  GApp2
//
//  Created by Robert Talianu
//

import Foundation

public class FileSystem {
       
    /**
     * Write the file of incomming gestures mapping data
     *
     * @param gestures
     */
    public static func writeIncommingGesturesMappingsDataFile(_ gestures: [InGestureMapping]) -> Void {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(Device.IncommingGesturesDataFileName)
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            //encoder.keyEncodingStrategy = .convertToSnakeCase
            //encoder.dateEncodingStrategy = .iso8601
            //encoder.dataEncodingStrategy = .base64
            try encoder
                .encode(gestures)
                .write(to: fileURL)
        } catch {
            Globals.log("Error saving incommingGesturesDataFile JSON: \(error)")
        }
    }
    
    
    /**
     *  Read the file of incomming gestures mapping data
     *
     * @return gestures
     */
    public static func readIncommingGesturesMappingDataFile() -> [InGestureMapping] {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent(Device.IncommingGesturesDataFileName)
            
            let data = try Data(contentsOf: fileURL)
            let pastData = try JSONDecoder().decode([InGestureMapping].self, from: data)
            
            return pastData
        } catch {
            Globals.log("Error reading incommingGesturesDataFile JSON: \(error)")
            return []
        }
    }
}

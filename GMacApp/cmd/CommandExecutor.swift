//
//  CommandExecutor.swift
//  GMacApp
//
//  Created by Robert Talianu
//

import Foundation


class CommandExecutor {
    
    // not working !?
   public static func executeCommand(_ command: String) {
        //Process.launchedProcess(launchPath: "/bin/sh", arguments: ["ls"])
        
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/bin/sh")
        task.arguments = [command] //["ls"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        do {
            try task.run()
            task.waitUntilExit()
            
        } catch {
            Globals.logToScreen("CommandExecutor: Error: \(error)")
        }
    }
    
    //
    // Tested & working
    //
    public static func shell(_ command: String) -> Int32 {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["bash", "-c", command]
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
    
    //
    //
    public static func shell2(_ command: String) -> (String?) {
        let task = Process()

        task.launchPath = "/bin/zsh"
        task.arguments = ["-c", command]

        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        task.waitUntilExit()
        return (output)
    }
}

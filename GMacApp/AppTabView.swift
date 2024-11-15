import CoreMotion
//
//  AppTabView.swift
//  GApp
//
//  Created by Robert Talianu
//
import SwiftUI

struct AppTabView: View {
    //private var analyser: RealtimeMultiGestureAnalyser
    //private var eventsHandler: AccelerometerEventHandler
    private var dataView: DataView
    private var keys: [String]

    // The app panel
    var body: some View {
        return VStack {
            //add buttons
            HStack {
                Spacer()
                Button("First") {
                    Globals.logToScreen("First Button Pressed")
                    //eventsHandler.clearRecordingData(keys[0])
                    //eventsHandler.setToRecording(keys[0])
                    //TODO... update keys iterator
                }
                Button("Second") {
                    Globals.logToScreen("Second Button Pressed")
                    //eventsHandler.clearRecordingData(keys[1])
                    //eventsHandler.setToRecording(keys[1])
                    //TODO... update keys iterator
                }
                Button("Third") {
                    Globals.logToScreen("3rd Button!")
                    //eventsHandler.clearRecordingData(keys[2])
                    //eventsHandler.setToRecording(keys[2])
                    //TODO... update keys iterator
                }
                Button("Test") {
                    Globals.logToScreen("Testing Clicked !!!...")
                    //eventsHandler.clearTestingData()
                    //eventsHandler.setToRealtimeTesting()
                    //TODO... update keys iterator
                }
                Button("Mock") {
                    //MockGenerator.toggleListener()
                    Globals.logToScreen("Mock Button Pressed")
                    //MockGenerator.toggleListener(eventsHandler)
                }
                Spacer()
            }

            //add data view panel
            dataView
        }
    }

    // constructor
    init() {
        //initilize app vars
        self.keys = ["A", "B", "C"]

        //Create & link Gesture Analyser
        //analyser = RealtimeMultiGestureAnalyser(keys)

        //Create the view  and wire it
        dataView = DataView()
        //dataView.setDataProvider(analyser)

        //pview.setStateProvider(eventsHandler);
        //analyser.setChangeListener(dataView)
        //analyser.setEvalListener(dataView)
        Globals.logToScreen("Gesture analyser created and wired...")

        //Create & link accelerometer events handler
        //eventsHandler = AccelerometerEventHandler(analyser)
        Globals.logToScreen("Event handler created...")

        // Create a CMMotionManager instance
        Globals.logToScreen("Initializing Sensor Manager...")
        //SensorMgr.registerListener(eventsHandler)
        //SensorMgr.startAccelerometers(Device.View_Accelerometer_Interval)

        Globals.logToScreen("Starting mock generator...")
        //MockGenerator.start()
        Globals.logToScreen("Mock generator connected...")

    }
}

//
//  AdEventHandler.swift
//  flutter_gromore
//
//  Created by Anand on 2022/6/2.
//

class AdEventHandler: NSObject, FlutterStreamHandler {
    static let instance: AdEventHandler = AdEventHandler()
    private var eventSink: FlutterEventSink?
    
    func sendEvent(_ event: AdEvent) {
        if let sink = eventSink {
            sink(event.toMap())
        }
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}

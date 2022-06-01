//
//  FlutterGromoreBase.swift
//  flutter_gromore
//
//  Created by jlq on 2022/6/1.
//

import Foundation

protocol FlutterGromoreBase {
    var methodChannel: FlutterMethodChannel? { get set }
    /// 初始化广告
    func initAd()
}

extension FlutterGromoreBase {
        
    func initMethodChannel(channelName: String, messenger: FlutterBinaryMessenger) -> FlutterMethodChannel? {
        let methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
        return methodChannel
    }
    
    func postMessage(_ method: String, arguments: Any? = nil) {
        methodChannel?.invokeMethod(method, arguments: arguments)
    }
}

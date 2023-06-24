//
//  FlutterGromoreBannerFactory.swift
//  flutter_gromore
//
//  Created by Stahsf on 2023/6/24.
//

import Foundation

class FlutterGromoreBannerFactory: NSObject, FlutterPlatformViewFactory {
    
    private var messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return FlutterGromoreBanner(frame: frame, id: viewId, params: args, messenger: messenger)
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }
}

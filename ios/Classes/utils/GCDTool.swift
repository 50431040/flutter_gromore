//
//  GCDTool.swift
//  flutter_gromore
//
//  Created by Stahsf on 2023/7/20.
//

import Foundation

typealias GCDTask = (_ cancel: Bool) -> ()

class GCDTool: NSObject {
        
    @discardableResult static func gcdDelay(_ time: TimeInterval, task: @escaping () -> ()) -> GCDTask?{
        
        func dispatch_later(block: @escaping () -> ()) {
            let t = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        }
        
        var closure: (() -> Void)? = task
        var result: GCDTask?
        
        let delayedClosure: GCDTask = {
            cancel in
            if let closure = closure {
                if !cancel {
                    DispatchQueue.main.async(execute: closure)
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatch_later {
            if let result = result {
                result(false)
            }
        }
        
        return result
    }
    
    static func gcdCancel(_ task: GCDTask?) {
        task?(true)
    }
}

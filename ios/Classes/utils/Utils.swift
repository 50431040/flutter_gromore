//
//  Utils.swift
//  flutter_gromore
//
//  Created by jlq on 2022/5/31.
//

import Foundation

class Utils {
    // 获取ViewController
    static func getVC() -> UIViewController {
        let viewController = UIApplication.shared.windows.filter({ (w) -> Bool in
            w.isHidden == false
        }).first?.rootViewController
        
        return viewController!
    }
    
    static var getScreenWidth: Int {
        return Int(floor(UIScreen.main.bounds.width))
    }
}

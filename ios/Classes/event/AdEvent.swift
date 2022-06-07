//
//  AdEvent.swift
//  flutter_gromore
//
//  Created by Anand on 2022/6/2.
//

class AdEvent: NSObject {
    private var id: String
    private var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    func toMap() -> [String: String] {
        return [
            "id": id,
            "name": name
        ]
    }
}

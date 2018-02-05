//
//  BeamyMessage.swift
//  Beamy_iOS
//
//  Created by Rudd Fawcett on 2/14/18.
//  Copyright © 2018 Beamy. All rights reserved.
//

import Foundation

enum BeamyMessageType {
    case string, data, vibration
}

struct BeamyMessage<T> {
    var type: BeamyMessageType!
    var body: T?
    
    init(_  body: T,  type: BeamyMessageType) {
        self.body = body
        self.type = type
    }
    
    func toData() -> Data {
        if body is String {
            let str =  body as! String
            return str.data(using: .utf8)!
        }
        return Data()
    }
}

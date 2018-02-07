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
    var body: T!
    var dataString: String {
        get {
            return self.toDataString()
        }
    }
    
    init(_  body: T) {
        self.body = body
    }
    
    func toDataString() -> String {
        var bodyString = ""
        
        if self.body is String {
            bodyString = self.body as! String
        }
        
        if self.body is Data {
            let data = self.body as! Data
            bodyString = data.base64EncodedString(options: .init(rawValue: 0))
        }
        
        let payload: [String: String] = [
            "body": ,
            "type":
        ]
        
//        return
        return ""
    }
}

//
//  BeamyMessage.swift
//  Beamy_iOS
//
//  Created by Rudd Fawcett on 2/14/18.
//  Copyright © 2018 Beamy. All rights reserved.
//

import Foundation
import CoreBluetooth

enum BeamyMessageType {
    case string, data, vibration
}

struct BeamyMessage {
    // From broadcasted device...
    let rawData: [String : Any]
    var data: [String: Any] = [:]
    var messageID: String?
    
    // From client device...
    var body: Any!
    var dataString: String {
        get {
            return self.generate() ?? ""
        }
    }

    init(_  body: Any) {
        self.body = body
        self.rawData = [:]
    }
    
    init(data: [String : Any]) {
        self.rawData = data
        
        if let dataString = data[CBAdvertisementDataLocalNameKey] as? String {
            self.parse(dataString: dataString)
        }
    }
    
    private mutating func parse(dataString string: String) {
        do {
            if let decodedData = string.base64Decoded()?.data(using: .utf8) {
                let decodedDictionary = try JSONSerialization.jsonObject(with: decodedData, options: [])
                if let dictionary = decodedDictionary as? [String:String] {
                    self.body = dictionary["body"]
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func generate() -> String! {
        var payload:[String: String] = [:]
        
        if let value = self.body as? String {
            payload["body"] = value
        }
        else if let value = self.body as? Data {
            payload["body"] = value.base64EncodedString(options: .init(rawValue: 0))
        }
        
        do {
            let json = try JSONSerialization.data(withJSONObject: payload, options: [])
            let string = String(data: json, encoding: .utf8)
            return string!.base64Encoded()!
        } catch {
            print(error.localizedDescription)
            return ""
        }
    }
}

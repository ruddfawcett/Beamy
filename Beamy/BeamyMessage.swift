//
//  BeamyMessage.swift
//  Beamy_iOS
//
//  Created by Rudd Fawcett on 2/14/18.
//  Copyright © 2018 Beamy. All rights reserved.
//

import Foundation
import CoreBluetooth

/// The type of message this BeamyMessage is.
///
/// - string: Simple string, contains just text.
/// - data: Contains data representation of another object (image, sound, etc.)
/// - vibration: Is a gesture vibration, sends a signal for the other device to vibrate.
enum BeamyMessageType {
    case string, data, vibration
}

struct BeamyMessage {
    // MARK: - Variables used when receiving a message from another device.
    
    // The raw data contained in the advertisement data.
    let rawData: [String : Any]
    /// The data contained in the advertisement.
    var data: [String: Any] = [:]
    /// The ID of the message (a random string).
    var messageID: String?
    
    // MARK: - Variables used when sending a message from a client device.
    
    /// The body of the message.
    var body: Any!
    /// A  base64 representation of the entire message payload.
    var dataString: String {
        get {
            return self.generate() ?? ""
        }
    }

    /// Creates a new BeamyMessage from user provided data.
    ///
    /// - Parameter body: The message body.
    init(_  body: Any) {
        self.body = body
        self.rawData = [:]
    }
    
    /// Creates a new BeamyMessage from advertisement data.
    ///
    /// - Parameter data: The advertisementData from the CBPeripheralManagerDelegate.
    init(data: [String : Any]) {
        self.rawData = data
        
        if let dataString = data[CBAdvertisementDataLocalNameKey] as? String {
            self.parse(dataString: dataString)
        }
    }
    
    /// Parses a   base64 encoded dictionary representation..
    ///
    /// - Parameter string: The dataString to parse.
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
    
    /// Generates a base64 representation of a dictionary.
    ///
    /// - Returns: The base64 string.
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

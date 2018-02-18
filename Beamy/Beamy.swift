//
//  Beamy.swift
//  Beamy
//
//  Created by Rudd Fawcett on 1/26/18.
//  Copyright © 2018 Beamy. All rights reserved.
//

import Foundation
import CoreBluetooth

private class BeamySingleton {
    var UUID: String?
}

public class Beamy: NSObject  {
    static let sharedInstance = Beamy()
    private static let setup = BeamySingleton()

    
    /// The BeamyManager which handles the Bluetooth discovery and connections.
    let manager: BeamyManager?
    /// The UUID to broadcast/listen for.
    let UUID: String!
    /// Another identifier to be listened for.
    let identifier: String? = ""
    /// A list of peripherals which have been discovered.
    var peripherals: [CBPeripheral] = []
    
    /// Instantiates a new Beamy Object.
    ///
    /// - Parameter UUID: The UUID upon to listen/advertise for.
    class func initiate(UUID: String) {
        Beamy.setup.UUID = UUID
        _ = Beamy.sharedInstance
    }
    
    override init() {
        self.UUID = Beamy.setup.UUID
        guard UUID != nil else {
            fatalError("Use initiate first in order to create a new Beamy instance.")
        }
        
        manager = BeamyManager(CBUUID(string: self.UUID))
        super.init()
    }
    
    /// Braodcasts a message to all devices which are listening for the same UUID.
    ///
    /// - Parameter message: The BeamyMessage to broadcast.
    func broadcast(message: BeamyMessage) {
        self.manager?.advertise(message: message)
    }
    
    /// Broadcasts a message to a single device based upon a CBPeripheral.
    ///
    /// - Parameters:
    ///   - message: The BeamyMessage to be sent.
    ///   - peripheral: The  BeamyDevice receiving the message.
    func send(message: BeamyMessage, to peripheral: BeamyDevice)  {
        self.manager?.advertise(message: message, forTarget: peripheral)
    }
}

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
    
    let manager: BeamyManager?
    let UUID: String!
    let identifier: String? = ""
    
    var peripherals: [CBPeripheral] = []
    
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
    
    func broadcast(message: BeamyMessage<String>) {
        self.manager?.advertise(message: message)
    }
    
    func send(message: BeamyMessage<AnyObject>, to peripheral: BeamyDevice)  {
        self.manager?.advertise(message: message, forTarget: peripheral)
    }
}

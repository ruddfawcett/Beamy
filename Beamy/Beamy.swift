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
    var identifier: String?
}

public class Beamy: NSObject  {
    static let sharedInstance = Beamy()
    private static let setup = BeamySingleton()
    
    let manager: BeamyManager?
    let identifier: String!
    
    var peripherals: [CBPeripheral] = []
    
    class func initiate(identifier: String) {
        Beamy.setup.identifier = identifier
        _ = Beamy.sharedInstance
    }
    
    override init() {
        self.identifier = Beamy.setup.identifier
        guard identifier != nil else {
            fatalError("Use initiate first in order to create a new Beamy instance.")
        }
        
        manager = BeamyManager(self.identifier)
        super.init()
    }
    
    func broadcast(message: BeamyMessage<AnyObject>) {
        self.manager?.advertise(message: message)
    }
    
    func send(message: BeamyMessage<AnyObject>, to peripheral: BeamyDevice)  {
        self.manager?.advertise(message: message, forTarget: peripheral)
    }
}

//
//  BeamyDevice.swift
//  Beamy_iOS
//
//  Created by Rudd Fawcett on 1/30/18.
//  Copyright © 2018 Beamy. All rights reserved.
//

import Foundation
import CoreBluetooth

enum BeamyDeviceOS {
    case iOS, macOS, android, windows, unkown
}

struct BeamyDevice {
    var os: BeamyDeviceOS
    var lastSeen: TimeInterval = 0
    var peripheral: CBPeripheral
    
    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
        self.os = .unkown
//        self.lastSeen
    }
}


//  BeamyDevice.swift
//  Beamy_iOS
//
//  Created by Rudd Fawcett on 1/30/18.
//  Copyright © 2018 Beamy. All rights reserved.
//

import Foundation
import CoreBluetooth

/// The operating system of the device.
///
/// - iOS: iOS
/// - macOS: macOS
/// - android: Android
/// - windows: Windows
/// - unkown: Unknown
enum BeamyDeviceOS {
    case iOS, macOS, android, windows, unkown
}

/// Device Object defined
struct BeamyDevice {
    /// The operating system of the device.
    var os: BeamyDeviceOS
    /// The last time the device was detected.
    var lastSeen: TimeInterval = 0
    /// The underlying device peripheral.
    var peripheral: CBPeripheral
    
    /// Creates a new device based upon an underlying peripheral.
    ///
    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
        self.os = .unknown
//        self.lastSeen
    }
}


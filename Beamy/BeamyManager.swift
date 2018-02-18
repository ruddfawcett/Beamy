//
//  Scanner.swift
//  Beamy_iOS
//
//  Created by Rudd Fawcett on 1/26/18.
//  Copyright © 2018 Beamy. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

enum BeamyManagerAdvertisability {
    case poweredOn, poweredOff
}

/// The BeamyManager protocol which is observed by the user.
protocol BeamyManagerDelegate {
    /// Called when a device is discovered advertising the same UUID.
    ///
    /// - Parameters:
    ///   - device: The device that has been discovered.
    ///   - message: The BeamyMessage that the device is broadcasting.
    func manager(didDiscover device: BeamyDevice, withMessage message: BeamyMessage)
    
    /// Called when a device is connected to the current device using Bluetooth.
    ///
    /// - Parameter device: The BeamyDevice.
    func manager(didConnect device: BeamyDevice)
}

class BeamyManager: NSObject {
    /// The UUID to listen for/advertise to.s
    var UUID: CBUUID
    /// The underlying CBCentralManager.
    var centralManager: CBCentralManager!
    var peripheralManager: CBPeripheralManager!
    var dispatchQueue: DispatchQueue
    
    /// Whether or not the current device should be advertising information.
    var advertisability: BeamyManagerAdvertisability? {
        didSet(newValue) {
            if newValue == .poweredOff {
                self.peripheralManager.stopAdvertising()
            }
        }
    }
    
    /// The BeamyManager protocol.
    var delegate: BeamyManagerDelegate?
    
    /// Creates a  new BeamyManager based upon a UUID.
    ///
    /// - Parameter UUID: The UUID.
    required init(_ UUID: CBUUID) {
        self.UUID = UUID
        self.dispatchQueue = DispatchQueue(label: UUID.uuidString)
        
        super.init()
        
        self.centralManager = CBCentralManager(delegate: self, queue: self.dispatchQueue)
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: self.dispatchQueue)
    }
    
    
    /// Advertises a BeamyMessage to the surrounding Bluetooth devices.
    ///
    /// - Parameter message: The BeamyMessage to advertise.
    func advertise(message: BeamyMessage) {
        let advertisingData: [String : Any] =  [
            CBAdvertisementDataLocalNameKey: message.dataString,
            CBAdvertisementDataServiceUUIDsKey: [self.UUID]
            ]
        
        let characteristic = CBMutableCharacteristic(type: self.UUID, properties: CBCharacteristicProperties.read, value: message.dataString.data(using: .utf8), permissions: CBAttributePermissions.readable)
        
        let service: CBMutableService = CBMutableService(type: self.UUID, primary: true)
        service.characteristics = [characteristic]
        
        self.peripheralManager.add(service)
        self.peripheralManager.startAdvertising(advertisingData)
    }
    
    
    /// Advertises a BeamyMessage to a particular BeamyDevice.
    ///
    /// - Parameters:
    ///   - message: The BeamyMessage to advertise.
    ///   - target: The BeamyDevice to target.
    func advertise(message: BeamyMessage, forTarget target: BeamyDevice) {
        let advertisingData: [String : Any] =  [
            CBAdvertisementDataLocalNameKey: UIDevice.current.name,
            CBAdvertisementDataServiceUUIDsKey: [self.UUID.uuidString, target.peripheral.name!]
        ]
        
        let characteristic = CBMutableCharacteristic(type: self.UUID, properties: CBCharacteristicProperties.read, value: message.dataString.data(using: .utf8), permissions: CBAttributePermissions.readable)
        
        let service: CBMutableService = CBMutableService(type: self.UUID, primary: true)
        service.characteristics = [characteristic]
        
        self.peripheralManager.add(service)
        self.peripheralManager.startAdvertising(advertisingData)
    }
}

extension BeamyManager: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.centralManager.scanForPeripherals(withServices: [self.UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let message: BeamyMessage = BeamyMessage(data: advertisementData)
        let device = BeamyDevice(peripheral: peripheral)
        delegate?.manager(didDiscover: device, withMessage: message)
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
    }
}

extension BeamyManager: CBPeripheralManagerDelegate {
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("Advertising...")
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            print("Powered on...")
        }
    }
}

extension String {
    /// Base64 encodes a string.
    ///
    /// - Returns: The encoded string.
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    /// Decodes a base64 string.
    ///
    /// - Returns: The decoded string.
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}

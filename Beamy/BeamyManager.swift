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

enum BeamyManagerDiscoverability {
    case discoverable, hidden
}

protocol BeamyManagerDelegate {
    func manager(didDiscover device: BeamyDevice, withMessage message: BeamyMessage)
    func manager(didConnect device: BeamyDevice)
}

class BeamyManager: NSObject {
    var UUID: CBUUID
    var centralManager: CBCentralManager!
    var peripheralManager: CBPeripheralManager!
    var dispatchQueue: DispatchQueue
    
    var advertisability: BeamyManagerAdvertisability? {
        didSet(newValue) {
            if newValue == .poweredOff {
                self.peripheralManager.stopAdvertising()
            }
            else {
                self.advertise()
            }
        }
    }
    var discoverability: BeamyManagerDiscoverability?
    
    var delegate: BeamyManagerDelegate?
    
    required init(_ UUID: CBUUID) {
        self.UUID = UUID
        self.dispatchQueue = DispatchQueue(label: UUID.uuidString)
        
        super.init()
        
        self.centralManager = CBCentralManager(delegate: self, queue: self.dispatchQueue)
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: self.dispatchQueue)
    }
    
    func advertise() {
        let message = BeamyMessage("TEST")
        self.advertise(message: message)
    }
    
    func advertise(message: BeamyMessage<String>) {
        let advertisingData: [String : Any] =  [
            CBAdvertisementDataLocalNameKey: message.data.base64Encoded()!,
            CBAdvertisementDataServiceUUIDsKey: [self.UUID]
            ]
        
        let characteristic = CBMutableCharacteristic(type: self.UUID, properties: CBCharacteristicProperties.read, value: message.toData(), permissions: CBAttributePermissions.readable)
        
        let service: CBMutableService = CBMutableService(type: self.UUID, primary: true)
        service.characteristics = [characteristic]
        
        self.peripheralManager.add(service)
        self.peripheralManager.startAdvertising(advertisingData)
    }
    
    func advertise(message: BeamyMessage<AnyObject>, forTarget target: BeamyDevice) {
        let advertisingData: [String : Any] =  [
            CBAdvertisementDataLocalNameKey: UIDevice.current.name,
            CBAdvertisementDataServiceUUIDsKey: [self.UUID.uuidString, target.peripheral.name!]
        ]
        
        let characteristic = CBMutableCharacteristic(type: self.UUID, properties: CBCharacteristicProperties.read, value: message.toData(), permissions: CBAttributePermissions.readable)
        
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
        delegate?.manager(didDiscover: device, withData: data)
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
            self.advertise()
        }
    }
}

extension String {
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}

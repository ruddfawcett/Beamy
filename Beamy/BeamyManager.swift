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
    func manager(didDiscover device: BeamyDevice, withAdvertisementData data: BeamyAdvertisementData)
    func manager(didConnect device: BeamyDevice)
}

class BeamyManager: NSObject {
    var identifier: CBUUID
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
    
    required init(_ identifier: String) {
        self.identifier = CBUUID(string: identifier)
        self.dispatchQueue = DispatchQueue(label: identifier)
        
        super.init()
        
        self.centralManager = CBCentralManager(delegate: self, queue: self.dispatchQueue)
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: self.dispatchQueue)
    }
    
    func advertise() {
//        self.peripheralManager.startAdvertising([:])
    }
    
    func advertise(message: BeamyMessage<AnyObject>) {
        let advertisingData: [String : Any] =  [
            CBAdvertisementDataLocalNameKey: UIDevice.current.name,
            CBAdvertisementDataServiceUUIDsKey: [self.identifier]
            ]
        
        //        // create our characteristics
        //        CBMutableCharacteristic *characteristic =
        //            [[CBMutableCharacteristic alloc] initWithType:self.uuid
        //                properties:CBCharacteristicPropertyRead
        //                value:[self.username dataUsingEncoding:NSUTF8StringEncoding]
        //                permissions:CBAttributePermissionsReadable];
        //
        //        // create the service with the characteristics
        //        CBMutableService *service = [[CBMutableService alloc] initWithType:self.uuid primary:YES];
        //        service.characteristics = @[characteristic];
        //        [self.peripheralManager addService:service];
    
        self.peripheralManager.startAdvertising(advertisingData)
    }
    
    func advertise(message: BeamyMessage<AnyObject>, forTarget target: BeamyDevice) {
        let advertisingData: [String : Any] =  [
            CBAdvertisementDataLocalNameKey: UIDevice.current.name,
            CBAdvertisementDataServiceUUIDsKey: [self.identifier.uuidString, target.peripheral.name!]
        ]
        
        let characteristic = CBMutableCharacteristic(type: self.identifier, properties: CBCharacteristicProperties.read, value: message.toData(), permissions: CBAttributePermissions.readable)
        
        let service: CBMutableService = CBMutableService(type: self.identifier, primary: true)
        service.characteristics = [characteristic]
        
        self.peripheralManager.add(service)
        self.peripheralManager.startAdvertising(advertisingData)
    }
}

extension BeamyManager: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
        else {
            
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let UUIDKeys = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [String] {
            if UUIDKeys.contains(self.identifier.uuidString) { // or if also contains the other unique identifier
                let data: BeamyAdvertisementData = BeamyAdvertisementData(advertisementData)
                let device = BeamyDevice(peripheral: peripheral)
                delegate?.manager(didDiscover: device, withAdvertisementData: data)
            }
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
    }
}

extension BeamyManager: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            self.centralManager.scanForPeripherals(withServices: [self.identifier], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }
        else {
            
        }
    }
}

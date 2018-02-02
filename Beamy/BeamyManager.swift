//
//  Scanner.swift
//  Beamy_iOS
//
//  Created by Rudd Fawcett on 1/26/18.
//  Copyright © 2018 Beamy. All rights reserved.
//

import Foundation
import CoreBluetooth

enum BeamyManagerAdvertisability {
    case poweredOn, poweredOff
}

enum BeamyManagerDiscoverability {
    case discoverable, hidden
}

protocol BeamyManagerDelegate {
    func manager(didDiscover peripheral: CBPeripheral, withAdvertisementData data: BeamyAdvertisementData)
    func manager(didConnect peripheral: CBPeripheral)
}

class BeamyManager: NSObject {
    var identifier: String
    var identifiers: [String]
    var centralManager: CBCentralManager!
    var peripheralManager: CBPeripheralManager!
    var dispatchQueue: DispatchQueue
    
    var advertisability: BeamyManagerAdvertisability? {
        didSet(newValue) {
            if newValue == .poweredOff {
                self.peripheralManager.stopAdvertising()
            }
            else {
                self.startAdvertising()
            }
        }
    }
    var discoverability: BeamyManagerDiscoverability?
    
    var delegate: BeamyManagerDelegate?
    
    required init(_ identifier: String) {
        self.identifier = identifier
        self.dispatchQueue = DispatchQueue(label: identifier)
        
        super.init()
        
        self.centralManager = CBCentralManager(delegate: self, queue: self.dispatchQueue)
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: self.dispatchQueue)
    }
    
    func startAdvertising() {
        let advertisingData: [String : Any] =  [
            CBAdvertisementDataLocalNameKey:  "ASDFASDFASDF",
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
            if UUIDKeys.contains(self.identifier) { // or if also contains the other unique identifier
                let data: BeamyAdvertisementData = BeamyAdvertisementData(advertisementData)
                delegate?.manager(didDiscover: peripheral, withAdvertisementData: data)
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
            self.centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
        else {
            
        }
    }
}

//
//  BeamyData.swift
//  Beamy_iOS
//
//  Created by Rudd Fawcett on 2/2/18.
//  Copyright © 2018 Beamy. All rights reserved.
//

import Foundation
import CoreBluetooth

struct BeamyAdvertisementData {
    let rawData: [String : Any]
    let data: String!
    
    init(_ advertisementData: [String : Any]) {
        self.rawData = advertisementData
        self.data = advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? ""
    }
}

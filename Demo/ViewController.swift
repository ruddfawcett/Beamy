//
//  ViewController.swift
//  Demo
//
//  Created by Rudd Fawcett on 1/30/18.
//  Copyright © 2018 Beamy. All rights reserved.
//

import UIKit
import Beamy_iOS
import CoreBluetooth

class ViewController: UIViewController, BeamyManagerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Beamy.initiate(identifier: "com.ruddfawcett.Demo")
        Beamy.sharedInstance.manager!.delegate = self
    }
    
    func manager(didDiscover peripheral: CBPeripheral, withAdvertisementData data: BeamyAdvertisementData) {
        print(peripheral.name)
    }
    
    func manager(didConnect peripheral: CBPeripheral) {
        print(peripheral.name)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

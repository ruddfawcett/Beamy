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
    var alert: UIAlertController!
    var alertVisible: Bool = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.alert = UIAlertController()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Beamy.initiate(UUID: "2C22299E-6C85-4268-B25D-029DF577CA3D")
        Beamy.sharedInstance.manager!.delegate = self
    }
    
    func manager(didDiscover device: BeamyDevice, withMessage message: BeamyMessage) {
        if !self.alertVisible {
            self.alertVisible = true
            self.alert = UIAlertController(title: "Discovered Device", message: "\(device.peripheral.name ?? "N/A")", preferredStyle: UIAlertControllerStyle.alert)
            print(data.rawData)
            self.alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                self.alertVisible = false
            }))
            self.present(self.alert, animated: true, completion: nil)
        }
    }
    
    func manager(didConnect device: BeamyDevice) {
        print(device.peripheral.name ?? "N/A")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

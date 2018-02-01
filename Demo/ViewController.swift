//
//  ViewController.swift
//  Demo
//
//  Created by Rudd Fawcett on 1/30/18.
//  Copyright © 2018 Beamy. All rights reserved.
//

import UIKit
import Beamy_iOS

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let scanner = BeamyScanner.sharedInstance
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


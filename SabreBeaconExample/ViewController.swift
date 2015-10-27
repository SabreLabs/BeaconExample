//
//  ViewController.swift
//  SabreBeaconExample
//
//  Created by barrett clark on 10/27/15.
//  Copyright © 2015 Barrett Clark. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, SabreLabsBeaconProtocol {

    var slBeacon = SabreLabsBeacon(proximityUUID: NSUUID(UUIDString: "F7826DA6-4FA2-4E98-8024-BC5B71E0893E"))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        slBeacon.delegate = self
    }
    
    func rangedBeacons(beacons: [AnyObject]) {
        NSLog("Found beacons: \(beacons)")
    }
    @objc func didDetermineState(state: CLRegionState) { }
    @objc func didEnterRegion(region: CLRegion) {  }
    @objc func didExitRegion(region: CLRegion) {  }
}

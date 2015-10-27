//
//  ExampleViewController.swift
//  AirportTravelerSwift
//
//  Created by barrett clark on 10/23/15.
//  Copyright © 2015 Barrett Clark. All rights reserved.
//

import UIKit
import CoreLocation

class ExampleViewController: UIViewController, SabreLabsBeaconProtocol {
    
    
    var slBeacon = SabreLabsBeacon(proximityUUID: NSUUID(UUIDString: "F7826DA6-4FA2-4E98-8024-BC5B71E0893E"))  /* Kontakt beacons */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        slBeacon.delegate = self
    }
    
    // MyCoreLocationProtocol delegate
    func didUpateLocation(location: CLLocation) {
        NSLog("VC Did Update Location: \(location)")
    }
    
    // MyBeaconProtocol delegate
    func rangedBeacons(beacons: [AnyObject]) {
        let idx = beacons.endIndex
        let beacon = beacons[idx-1] as! CLBeacon
        NSLog("Closest beacon: \(beacon.major) \(beacon.minor)")
    }
    
    func didDetermineState(state: CLRegionState) {
        if (state == .Unknown) {
            NSLog("No more beacon(s)")
        }
    }
}

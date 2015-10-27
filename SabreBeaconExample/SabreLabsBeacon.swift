//
//  SabreLabsBeacon.swift
//  AirportTravelerSwift
//
//  Created by barrett clark on 10/23/15.
//  Copyright © 2015 Barrett Clark. All rights reserved.
//

import Foundation
import CoreLocation

@objc protocol SabreLabsBeaconProtocol {
    func rangedBeacons(beacons: [AnyObject])
    optional func didDetermineState(state: CLRegionState)
    optional func didEnterRegion(region: CLRegion)
    optional func didExitRegion(region: CLRegion, major: Int)
}

@objc class SabreLabsBeacon: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var sabreRegion = CLBeaconRegion()
    var proximityUUID = NSUUID()
    var delegate: SabreLabsBeaconProtocol?
    var recentMajor: Int?
    
    init(proximityUUID: NSUUID?) {
        super.init()
        if (proximityUUID != nil) {
            self.proximityUUID = proximityUUID!
        }
        if(locationManager.respondsToSelector("requestAlwaysAuthorization")) {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.delegate = self
        locationManager.pausesLocationUpdatesAutomatically = false
        sabreRegion = CLBeaconRegion(proximityUUID: proximityUUID!, identifier: "Sabre Airport")
        sabreRegion.notifyEntryStateOnDisplay = true
        locationManager.startMonitoringForRegion(sabreRegion)
    }
    
    // Beacon Delegates -- responding to region events
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        // tells the delegate that the new region is being monitored
        locationManager.requestStateForRegion(sabreRegion)
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Error: monitoringDidFailForRegion")
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        self.delegate?.didDetermineState!(state)
        switch state {
        case .Inside:
            locationManager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
        case .Outside:
            return
        default:
            locationManager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        }
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("entered region \(region)")
        self.delegate?.didEnterRegion!(region)
    }
    
    func locationManager(manager: CLLocationManager,didExitRegion region: CLRegion){
        print("exited region \(region)")
        self.delegate?.didExitRegion!(region, major: recentMajor!)
        self.recentMajor = nil
    }
    
    // Beacon Delegates -- responding to ranging events
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        print("Found \(beacons.count) beacons")
        if (beacons.count > 0) {
            var goodBeacons: Array<CLBeacon> = []
            for b in beacons {
                print("Major: \(b.major), Minor: \(b.minor), Proximity: \(b.proximity.rawValue), Accuracy: \(b.accuracy)")
                if (b.accuracy > 0) {
                    goodBeacons.append(b)
                }
            }
            if (goodBeacons.count > 0) {
                self.recentMajor = goodBeacons.first?.major as? Int
                self.delegate?.rangedBeacons(goodBeacons)
            }
        }
    }
}
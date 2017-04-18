//
//  BeaconManager.swift
//  RegionMonitoringSwift
//
//  Created by Nicolas Flacco on 6/25/14.
//  Adapted/Fixed/Packaged by Dominik Pich 2017
//

import CoreLocation
import UIKit

public protocol BeaconManagerDelegate: class {
    func startedInRegion(regionUUID: NSUUID)
    func didEnterRegion(regionUUID: NSUUID)
    func didExitRegion(regionUUID: NSUUID)
}

public class BeaconManager: NSObject, CLLocationManagerDelegate    {
    private var locationManager: CLLocationManager = CLLocationManager()
    private(set) var regions = [CLBeaconRegion]()
    private var startedMonitoring = false
    weak var delegate: BeaconManagerDelegate?
    
    public override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func start(regionUUIDs:[NSUUID], delegate : BeaconManagerDelegate?) {
        if regions.count > 0 {
            stop()
        }
        
        print("BM start");
        self.delegate = delegate
        
        for regionUUID in regionUUIDs {
            let r = CLBeaconRegion(proximityUUID: regionUUID as UUID, identifier: regionUUID.uuidString)
            regions.append(r)
        }
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            locationManager.requestAlwaysAuthorization()
        }
        else {
            startMonitoring()
        }
    }
    
    public func stop() {
        print("BM stop");
        
        if startedMonitoring {
            for region in regions {
                locationManager.stopMonitoring(for: region)
            }
        }
        
        regions.removeAll()
        startedMonitoring = false
    }
    
    private func startMonitoring() {
        guard !startedMonitoring else {
            print("BM already started before")
            return;
        }
        
        for region in regions {
            locationManager.startMonitoring(for: region)
        }
        startedMonitoring = true
    }
    
    //  CLLocationManagerDelegate methods

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("BM didChangeAuthorizationStatus: \(status)")
        startMonitoring()
    }
    
    public func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("BM didStartMonitoringForRegion")
        locationManager.requestState(for: region) // should locationManager be manager?
    }
    
    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("BM didEnterRegion \(region.identifier)")

        guard let region = region as? CLBeaconRegion else {
            print("BM ignoring non beacon region")
            return
        }
        delegate?.didEnterRegion(regionUUID: region.proximityUUID as NSUUID)
    }
    
    public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("BM didExitRegion \(region.identifier)")
        
        guard let region = region as? CLBeaconRegion else {
            print("BM ignoring non beacon region")
            return
        }
        delegate?.didExitRegion(regionUUID: region.proximityUUID as NSUUID)
    }
    
    public func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        print("BM didDetermineState \(state)");
        
        guard let region = region as? CLBeaconRegion else {
            print("BM ignoring non beacon region")
            return
        }

        switch state {
        case .inside:
            print("BeaconManager:didDetermineState CLRegionState.Inside \(region.identifier)");
            delegate?.startedInRegion(regionUUID: region.proximityUUID as NSUUID)
        case .outside:
            print("BeaconManager:didDetermineState CLRegionState.Outside");
        case .unknown:
            print("BeaconManager:didDetermineState CLRegionState.Unknown");
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        // This is needed for region enter/exit
    }
}

//
//  ViewController.swift
//  EywaSDKDemo
//
//  Created by Srinivasa Reddy on 11/20/19.
//  Copyright © 2019 EywaMedia. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet var ble_status_label : UILabel!
    @IBOutlet var beacon_uuid_label : UILabel!
    @IBOutlet var beacon_major_label : UILabel!
    @IBOutlet var beacon_minor_label : UILabel!
    @IBOutlet var beacon_distance_label : UILabel!
    @IBOutlet var noBeacons_label : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.beacon_uuid_label.text = ""
        self.beacon_major_label.text = ""
        self.beacon_minor_label.text = ""
        self.beacon_distance_label.text = ""
        self.ble_status_label.text = ""
        
        setupEywaSDK()
    }

    func setupEywaSDK() {
        
        let mgr = EywaSDKCodeManager.SharedManager
        mgr.kLicenseKey = "IOS_TEST"
        mgr.licenseKeyCheck() {
            (isValidLicense: Bool) in
            
            if isValidLicense {
                
                print("Valid License")
                
                let reach = EywaSDKNetworkReachability.sharedInstance
                reach.delegate = self
                
                let bluetoothManager = EywaSDKBluetoothManager.sharedInstance
                bluetoothManager.delegate = self
                
                let beaconReceiver = EywaSDKBeaconReceiver.sharedInstance
                beaconReceiver.delegate = self
            }
            else {
                
                print("Invalid License Key.")
            }
        }
    }

}

extension ViewController : EywaSDKNetworkReachabilityDelegate  {
    
    func didConnectedToWifi(routerName: String) {
        
        print("DetectedSSID is \(routerName)")
    }
}

extension ViewController : BeaconReceiverDelegate {

    func BeaconEstimatedDistance(beaconInfo: Dictionary<String, Any>, beaconDistance: CLBeacon) {
        
        print("Distance is \(beaconDistance.accuracy)")
        
        let accuracy = String(format: "%.2f", beaconDistance.accuracy)
        
        self.beacon_uuid_label.text = beaconInfo["UUID"] as? String
        self.beacon_major_label.text = beaconInfo["Major"] as? String
        self.beacon_minor_label.text = beaconInfo["Minor"] as? String
        self.beacon_distance_label.text = "\(accuracy) meters"
        
        self.noBeacons_label.text = ""
    }
    
    func ClosestBroadcastedBeaconInfo(beaconName: String) {
        
        print("Closest Beacon is \(beaconName)")
    }
    
    func AllBroadcastedBeaconsInfo(beaconInfo: Dictionary<String, Any>) {
        
        print("Detected Beacon is \(beaconInfo["Name"] ?? "")")
    }
    
    func noBeaconsInRange() {
        
        self.beacon_uuid_label.text = ""
        self.beacon_major_label.text = ""
        self.beacon_minor_label.text = ""
        self.beacon_distance_label.text = ""
        self.noBeacons_label.text = "No Beacons In Range"
    }
}

extension ViewController : BluetoothStatusDelegate {
    
    func bluetoothStatusUpdate(status: String) {
        
        self.ble_status_label.text = status
    }
}


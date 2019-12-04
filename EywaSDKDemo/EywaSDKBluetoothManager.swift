//
//  EywaSDKBluetoothManager.swift
//  EywaSDK
//
//  Created by Srinivasa Reddy on 8/14/19.
//  Copyright © 2019 Eywamedia. All rights reserved.
//

import UIKit
import Foundation
import CoreBluetooth

public protocol BluetoothStatusDelegate {
    
    func bluetoothStatusUpdate(status: String)
}

public class EywaSDKBluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    public static let sharedInstance: EywaSDKBluetoothManager = {
        let instance = EywaSDKBluetoothManager()
        return instance
    }()
    
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    public var delegate: BluetoothStatusDelegate?
    
    public override init() {
        
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // MARK: CBCentralManagerDelegate
    public func centralManagerDidUpdateState(_ central:CBCentralManager) {
        
        switch central.state {
        case CBManagerState.poweredOn:
            print("EywaSDK - Bluetooth powered On")
            delegate?.bluetoothStatusUpdate(status: "ON")
        case CBManagerState.poweredOff:
            print("EywaSDK - Bluetooth powered Off")
            delegate?.bluetoothStatusUpdate(status: "OFF")
        case CBManagerState.unsupported:
            print("EywaSDK - Bluetooth low energy hardware not supported.")
            delegate?.bluetoothStatusUpdate(status: "NOT SUPPORTED")
        case CBManagerState.unauthorized:
            print("EywaSDK - Bluetooth unauthorized state.")
            delegate?.bluetoothStatusUpdate(status: "UNAUTHORIZED")
        case CBManagerState.unknown:
            print("EywaSDK - Bluetooth unknown state.")
            delegate?.bluetoothStatusUpdate(status: "NA")
        default:
            print("EywaSDK - Bluetooth unknown state.")
            delegate?.bluetoothStatusUpdate(status: "NA")
        }
        
    }
}

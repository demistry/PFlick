//
//  NetworkMonitoringManager.swift
//  PFlick
//
//  Created by David Ilenwabor on 28/08/2020.
//  Copyright © 2020 Davidemi. All rights reserved.
//

import Foundation
import Reachability
import SystemConfiguration

class NetworkManager : NSObject{
    
    var reachability : Reachability?
    static let sharedInstance = NetworkManager()
    override init(){
        super.init()
        reachability = try? Reachability()
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged), name: .reachabilityChanged, object: nil)
        do {
            try reachability?.startNotifier()
        } catch{
            print("Failed to start network notifier...")
        }
    }
    
    func startNotifier(){
        do {
            try reachability?.startNotifier()
        } catch{
            print("Failed to start network notifier...")
        }
    }
    
    func stopNotifier() -> Void {
        (NetworkManager.sharedInstance.reachability)?.stopNotifier()
    }
    
    static func isReachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability)?.connection != .unavailable {
            completed(NetworkManager.sharedInstance)}
    }
    
     static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {if
        (NetworkManager.sharedInstance.reachability)?.connection == .unavailable {
            completed(NetworkManager.sharedInstance)
    }}
    
    
    @objc private func networkStatusChanged(_ notification : Notification){
    }
    
    func connectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return (isReachable && !needsConnection)
    }
}

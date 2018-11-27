//
//  ZLLocationStrategy.swift
//  GoogleMap
//
//  Created by Jeffery on 2018/11/27.
//  Copyright © 2018年 Zilly. All rights reserved.
//

import UIKit
import GoogleMaps

enum ZLIdentify {
    case car
    case human
}

struct ZLLocation {
    var location : CLLocation?
    var zlIdentify :ZLIdentify
}
class ZLLocationFilterStrategy: NSObject {
    
    let carTimeThreshold = 10.0          //unit : s
    let cardDistanceThreshold = 50.0     //unit : m
    let humanRangeThreshold = 1000.0          //unit : m
    let humanTimeThreshold = 300.0           //unit : second
    
    var isFindNode : Bool?
    var loactionArray = Array<ZLLocation>()
    var nodeArray = Array<ZLLocation>()
    
     // MARK: Life Cycle
    override init() {
        super.init()
        
    }
    
    /// detect the best node
    ///
    /// - Parameters:
    ///   - currentLocation: currentLocation
    ///   - lastLocation: lastLocation
    /// - Returns: make sure is a node
    func detectBestNode(_ currentLocation: CLLocation, _ lastLocation: CLLocation) {
        
        let currentTime = currentLocation.timestamp.timeIntervalSince1970
        let lastTime = lastLocation.timestamp.timeIntervalSince1970
        let tempTime = (currentTime - lastTime)
        
        // 获取两点之间的距离
        let distance = currentLocation.distance(from: lastLocation)
        
        if tempTime < carTimeThreshold && distance > cardDistanceThreshold {
            //now is car
            isFindNode = false
            let zlidentify = ZLIdentify.car
            let currentL =  ZLLocation.init(location: lastLocation, zlIdentify: zlidentify)
            self.loactionArray.append(currentL)
            
        }else{
            //now is human
            let zlidentify = ZLIdentify.human
            let currentL =  ZLLocation.init(location: lastLocation, zlIdentify: zlidentify)
            self.loactionArray.append(currentL)
            
            guard isFindNode == false else {
                return
            }
            
            let (flag,nodeLocation) = backtracking(self.loactionArray, currentL)
            if flag == true {
                isFindNode = true
                self.nodeArray.append(nodeLocation)
            }
        }
    }
    
    func backtracking(_ locations:Array<ZLLocation>,_ currentLocation :ZLLocation) -> (Bool,ZLLocation){
        
        guard locations.count > 1 else {
            return (false,currentLocation)
        }
        
        var temp : ZLLocation?
        for  zlo in locations.reversed() {
            if zlo.zlIdentify == ZLIdentify.car {
                temp = zlo
                break
            }
        }
        
        guard temp != nil else {
              return (false,currentLocation)
        }
        
        let currentTime = currentLocation.location!.timestamp.timeIntervalSince1970
        let lastTime = temp!.location!.timestamp.timeIntervalSince1970
        let tempTime = (currentTime - lastTime)
        
        let distance = currentLocation.location!.distance(from: temp!.location!)
        if tempTime > humanTimeThreshold && distance < humanRangeThreshold {
            //now find the node
            return (true,temp!)
        }
        return (false,currentLocation)
    }
}











// MARK: - 地理编码
extension ZLLocationFilterStrategy {
    
    /// 反地理编码
    ///
    /// - Parameter location: CLLocation
    /// - Returns: name
    func reverseGeocoder(_ location: CLLocation, completion:@escaping ((_ name: String?)->())) {
        let coder = CLGeocoder()
        coder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            }
            guard let placemarksArray = placemarks else { return }
            if placemarksArray.count > 0 {
                let placeMark = placemarksArray.first!
                print(placeMark)
                completion(placeMark.name)
            } else {
                completion(nil)
            }
        }
    }
}

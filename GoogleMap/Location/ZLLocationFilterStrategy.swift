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
        let duration = (currentTime - lastTime)
        
        // 获取两点之间的距离
        let distance = currentLocation.distance(from: lastLocation)
        
        if duration < carTimeThreshold && distance > cardDistanceThreshold {
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
                var startNode:ZLLocation?
                if self.nodeArray.count > 0 {
                    startNode = self.nodeArray.last
                }else{
                    startNode =  self.loactionArray.first
                }
               
                //fisrt insert to the sqlite
                ZLDataManager.init().insertData(startNode!, nodeLocation, self.loactionArray)
                self.loactionArray.removeAll()
                self.nodeArray.append(nodeLocation)
            }
        }
    }
    
    func backtracking(_ locations:Array<ZLLocation>,_ currentLocation :ZLLocation) -> (Bool,ZLLocation){
        
        guard locations.count > 1 else {
            return (false,currentLocation)
        }
        
        var nodeLocation : ZLLocation?
        for  zlo in locations.reversed() {
            if zlo.zlIdentify == ZLIdentify.car {
                nodeLocation = zlo
                break
            }
        }
        
        guard nodeLocation != nil else {
              return (false,currentLocation)
        }
        
        let currentTime = currentLocation.location!.timestamp.timeIntervalSince1970
        let lastTime = nodeLocation!.location!.timestamp.timeIntervalSince1970
        let duration = (currentTime - lastTime)
        
        let distance = currentLocation.location!.distance(from: nodeLocation!.location!)
        if duration > humanTimeThreshold && distance < humanRangeThreshold {
            //now find the node
            return (true,nodeLocation!)
        }
        return (false,currentLocation)
    }
}




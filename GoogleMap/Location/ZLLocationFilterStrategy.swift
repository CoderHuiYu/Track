//
//  ZLLocationStrategy.swift
//  GoogleMap
//
//  Created by Jeffery on 2018/11/27.
//  Copyright © 2018年 Zilly. All rights reserved.
//

import UIKit
import GoogleMaps

struct ZLLocation {
    var location : CLLocation?
    var defaultName:String?
    
}
class ZLLocationFilterStrategy: NSObject {
    
    var locations = Array<CLLocation>()
    let speedThreshold = 5     //unit : m/s
    let rangeThreshold = 1000  //unit : m
    let timeThreshold = 300    //unit : second
    
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
    func detectBestNode(_ currentLocation: CLLocation, _ lastLocation: CLLocation) -> Bool {
        let currentTime = currentLocation.timestamp.timeIntervalSince1970
        let lastTime = lastLocation.timestamp.timeIntervalSince1970
        let tempTime = (currentTime - lastTime)
        
        // 获取两点之间的距离 m
        let distance = currentLocation.distance(from: lastLocation)
        
        // 判断停留时间 和 停留距离
        if tempTime > 0.5 * 60 && distance < 1000 {
            print("停留时间>5min")
            return true
        } else {
            
            print("两点之间的时间:\(tempTime)")
            
            print("两点之间的距离:\(distance)")
            
            return false
        }
    }
}
// MARK: - 地理编码
extension ZLLocationManager {
    
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

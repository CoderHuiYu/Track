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
    
    func filterBestNode(_ locations:Array<CLLocation>) -> CLLocation {
      let location : CLLocation =  locations.last!
      print("speed\( location.speed)","time\(location.timestamp)")
      let a = CLLocation.init()
      return a
    }
}

//
//  ZLTrackModel.swift
//  GoogleMap
//
//  Created by 余辉 on 2018/11/28.
//  Copyright © 2018年 Zilly. All rights reserved.
//

import UIKit
import GoogleMaps
class ZLTrackModel: NSObject {
    
    var startNode :ZLLocation?
    var endNode :ZLLocation?
    var locations = Array<ZLLocation>()
    
    init(_ dict: [String:Any]) {
        
        let start_latitude = Double.init(dict["start_latitude"] as! String)
        let start_longitude = Double.init(dict["start_longitude"] as! String)
        //        let start_timestamp = dict["start_timestamp"]
        
        let end_latitude = Double.init(dict["end_latitude"] as! String)
        let end_longitude = Double.init(dict["end_longitude"] as! String)
        //        let end_timestamp = dict["end_timestamp"]
        
       
        let startLocation =  CLLocation.init(latitude: start_latitude!  , longitude: start_longitude! )
        
        let endLocation =  CLLocation.init(latitude: end_latitude!  , longitude: end_longitude! )
        let startNode = ZLLocation.init(location: startLocation, zlIdentify: ZLIdentify.human)
        let endNode = ZLLocation.init(location: endLocation, zlIdentify: ZLIdentify.human)
        
        self.startNode = startNode
        self.endNode = endNode
        
        guard let locations = dict["locations"] as? String else {
            return
        }
        guard let locs = ZLDataManager.init().getArrayFromJSONString(jsonString: locations) as? [[Double]] else{
            return
        }
        
        for loc in locs {
            let tempCol = CLLocation.init(latitude: loc[0] , longitude: loc[1])
            let tempZol =  ZLLocation.init(location: tempCol, zlIdentify: ZLIdentify.human)
            self.locations.append(tempZol)
        }
    }
}



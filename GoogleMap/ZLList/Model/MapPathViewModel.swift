//
//  MapPathViewModel.swift
//  GoogleMap
//
//  Created by Pratik Lad on 05/11/17.
//  Copyright © 2017 Pratik Lad. All rights reserved.
//

import UIKit
import CoreLocation

protocol MapPathViewModelDelegate {
    func isSucessReadJson()
    func isFailReadJson(msg : String)
}
class MapPathViewModel {

    var delegate : MapPathViewModelDelegate?
    var arrayMapPath : [MapPath] = []
    
    //Json File data get
    func jsonDataRead(_ location: ZLTrackModel) {
        parseJson(location)
    }
    
    //Pars json from array
    func parseJson(_ location : ZLTrackModel)  {
        
        var locations = [CLLocation]()
        
        guard let startNode = location.startNode, let startLocation = startNode.location else {
            return
        }
        locations.insert(startLocation, at: 0)
        
        if location.locations.count > 0 {
            
            for cl in location.locations {
                guard let cll = cl.location else { break }
                locations.append(cll)
            }
            
        }
        
        guard let endNode = location.endNode, let endLocation = endNode.location else {
            return
        }
        locations.append(endLocation)
        
        
        
        
        for data in locations {
            let lat = data.coordinate.latitude
            let lon = data.coordinate.longitude
    
            arrayMapPath.append(MapPath(lat: lat, lon: lon))
        }
        
        if arrayMapPath.count > 0
        {
            delegate?.isSucessReadJson()
        }
    }
    
}

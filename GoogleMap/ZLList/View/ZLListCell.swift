//
//  ZLListCell.swift
//  GoogleMap
//
//  Created by apple on 2018/11/28.
//  Copyright © 2018 Zilly. All rights reserved.
//

import UIKit
import GoogleMaps
class ZLListCell: UITableViewCell {
    
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    var objMapModel = MapPathViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        mapView.settings.scrollGestures = false
//        mapView.settings.zoomGestures = false
        mapView.isUserInteractionEnabled = false
        
        objMapModel.delegate = self
//        objMapModel.jsonDataRead()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}

// MARK: - MapPathViewModelDelegate
extension ZLListCell: MapPathViewModelDelegate {
    
    func isSucessReadJson() {
        drawPathOnMap()
    }
    
    func isFailReadJson(msg: String) {
        
    }
    
    //path create
    func drawPathOnMap()  {
        let path = GMSMutablePath()
        let marker = GMSMarker()
        var i = 0
        
        let inialLat:Double = objMapModel.arrayMapPath[0].lat
        let inialLong:Double = objMapModel.arrayMapPath[0].lon
        
        for mapPath in objMapModel.arrayMapPath
        {
            if i == 0{
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2DMake(mapPath.lat, mapPath.lon)
                //                marker.icon = UIImage(named: "map_location_blue")
                marker.title = "Company"
                marker.snippet = "Work"
                marker.map = mapView
            }
            i = i + 1
            if i == objMapModel.arrayMapPath.count-1{
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2DMake(mapPath.lat, mapPath.lon)
                //                marker.icon = UIImage(named: "map_location_blue")
                marker.title = "Company"
                marker.snippet = "Work"
                marker.map = mapView
            }
            path.add(CLLocationCoordinate2DMake(mapPath.lat, mapPath.lon))
        }
        //set poly line on mapview
        let rectangle = GMSPolyline(path: path)
        rectangle.strokeWidth = 5.0
        marker.map = mapView
        rectangle.map = mapView
        
        //Zoom map with path area
        let loc : CLLocation = CLLocation(latitude: inialLat, longitude: inialLong)
        updateMapFrame(newLocation: loc, zoom: 11.0)
    }
    
    func updateMapFrame(newLocation: CLLocation, zoom: Float) {
        let camera = GMSCameraPosition.camera(withTarget: newLocation.coordinate, zoom: zoom)
        self.mapView.animate(to: camera)
    }
    
}

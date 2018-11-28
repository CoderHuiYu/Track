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
    
    @IBOutlet weak var mileLabel: UILabel!
    
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    var objMapModel = MapPathViewModel()
    
    var model: ZLTrackModel? {
        didSet {
            
            guard let model = model else {
                return
            }
            
            objMapModel.jsonDataRead(model)
            
            guard let startNode = model.startNode, let startLocation = startNode.location else {
                return
            }
            
            self.startTextField.text = "\(startLocation.coordinate.latitude) + \(startLocation.coordinate.longitude)"
        
            
            self.mileLabel.text = "\(1000)"
//            ZLLocationManager.shared.reverseGeocoder(startLocation) { (str) in
//                guard let name = str else {
//                    self.startTextField.text = "\(startLocation.coordinate.latitude) + \(startLocation.coordinate.longitude)"
//                    return
//                }
//                self.startTextField.text = name
//            }
            
            
            guard let endNode = model.endNode, let endLocation = endNode.location else {
                return
            }
            
            self.endTextField.text = "\(endLocation.coordinate.latitude) + \(endLocation.coordinate.longitude)"
            
//            ZLLocationManager.shared.reverseGeocoder(endLocation) { (str) in
//                guard let name = str else {
//                    self.endTextField.text = "\(endLocation.coordinate.latitude) + \(endLocation.coordinate.longitude)"
//                    return
//                }
//                self.endTextField.text = name
//            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        mapView.settings.scrollGestures = false
//        mapView.settings.zoomGestures = false
        mapView.isUserInteractionEnabled = false
        startTextField.isUserInteractionEnabled = false
        endTextField.isUserInteractionEnabled = false
        
        objMapModel.delegate = self

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

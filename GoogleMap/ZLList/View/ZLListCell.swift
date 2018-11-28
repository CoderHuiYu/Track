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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        mapView.settings.scrollGestures = false
//        mapView.settings.zoomGestures = false
        mapView.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension ZLListCell {
    
}

//
//  ZLTrackTableViewCell.swift
//  GoogleMap
//
//  Created by 余辉 on 2018/11/28.
//  Copyright © 2018年 Zilly. All rights reserved.
//

import UIKit
import GoogleMaps
class ZLTrackTableViewCell: UITableViewCell {

    var distanceLabel:UILabel?
    
    var mapView:GMSMapView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        distanceLabel = UILabel()
        self.contentView.addSubview(distanceLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  ZLLocationManager.swift
//  GoogleMap
//
//  Created by apple on 2018/11/27.
//  Copyright © 2018 Sinowel. All rights reserved.
//

import UIKit
import CoreLocation
protocol ZLLocationManagerDelegateProtocol: NSObjectProtocol {
    func locationManager(didUpdateLocation location: CLLocation)
}
class ZLLocationManager: NSObject {

    static let shared: ZLLocationManager = ZLLocationManager()
    var filterStrategy : ZLLocationFilterStrategy?

    weak var delegate: ZLLocationManagerDelegateProtocol?
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        
        // 隐私服务请求
        locationManager.requestAlwaysAuthorization()
        // Set an accuracy level. The higher, the better for energy.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.distanceFilter = 50
        
        locationManager.pausesLocationUpdatesAutomatically = true
        // 允许后台
        locationManager.allowsBackgroundLocationUpdates = true

        locationManager.activityType = CLActivityType.automotiveNavigation // 汽车导航
        
        locationManager.delegate = self
        
        return locationManager
    }()
    
    // last location
    var lastLocation: CLLocation?
    
    override init() {
        super.init()
        
        filterStrategy = ZLLocationFilterStrategy.init()
        // 标准更改位置
        locationManager.startUpdatingLocation()
        // 重大位置更改
//        locationManager.startMonitoringSignificantLocationChanges()
    }
}

// MARK: - CLLocationManagerDelegate
extension ZLLocationManager: CLLocationManagerDelegate {
    
    // 隐私通知
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
    }

    // 监听location变化
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // If it's a relatively recent event, turn off updates to save power.
        print(locations.first!)
//        locations.first?.coordinate.longitude
        NotificationCenter.default.post(name: NSNotification.Name("updateLocation"), object: nil, userInfo: ["latitude":locations.first!.coordinate.latitude,"longitude":locations.first!.coordinate.longitude])
        
        guard let currentLocation = locations.last else { return }
        guard let theLastLocation = lastLocation else {
            lastLocation = currentLocation
            return
        }
        
        filterStrategy?.detectBestNode(currentLocation, theLastLocation)
        
        guard self.delegate == nil else {
            self.delegate!.locationManager(didUpdateLocation: theLastLocation)
            return
        }
      
    }
    
}



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

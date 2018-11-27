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
    
    /*  if you are monitoring regions or using the significant-change location service in your app, there are situations where you must start location services at launch time. Apps using those services can be terminated and subsequently relaunched when new location events arrive. Although the app itself is relaunched, location services are not started automatically. When an app is relaunched because of a location update, the launch options dictionary passed to your application:willFinishLaunchingWithOptions: or application:didFinishLaunchingWithOptions: method contains the UIApplicationLaunchOptionsLocationKey key. The presence of that key signals that new location data is waiting to be delivered to your app. To obtain that data, you must create a new CLLocationManager object and restart the location services that you had running prior to your app’s termination. When you restart those services, the location manager delivers all pending location updates to its delegate.
    */
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        
        // 省电
        // When this property is set to YES, Core Location pauses location updates (and powers down the location hardware) whenever it makes sense to do so, such as when the user is unlikely to be moving anyway. (Core Location also pauses updates when it can’t obtain a location fix.)
//        locationManager.pausesLocationUpdatesAutomatically = true
        // Assign an appropriate value to the location manager’s activityType property. The value in this property helps the location manager determine when it is safe to pause location updates. For an app that provides turn-by-turn automobile navigation, setting the property to CLActivityTypeAutomotiveNavigation causes the location manager to pause events only when the user does not move a significant distance over a period of time.
        locationManager.activityType = CLActivityType.automotiveNavigation // 汽车导航
        
//        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 允许后台
        locationManager.allowsBackgroundLocationUpdates = true
        // 新事件回调的阈值
        locationManager.distanceFilter = 5
        locationManager.delegate = self
        return locationManager
    }()
    
    // 当前记录路线
    lazy var pathArray = [CLLocation]()
    // 所有记录路线
    lazy var allPathArray = [[CLLocation]]()
    
    override init() {
        super.init()
        filterStrategy = ZLLocationFilterStrategy.init()
        // 隐私服务请求
        locationManager.requestAlwaysAuthorization()
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
        print("pathCount: \(pathArray.count) ~~~~~~ allPathCount: \(allPathArray.count)")
        // If it's a relatively recent event, turn off updates to save power.
        
        guard let currentLocation = locations.last else { return }
        
        guard let lastLocation = pathArray.last else {
            pathArray.append(currentLocation)
            return
        }
        let isNeedBreak = filterStrategy?.detectBestNode(currentLocation, lastLocation)
        if isNeedBreak! {
            allPathArray.append(pathArray)
            pathArray.removeAll()
        } else {
            pathArray.append(currentLocation)
        }
        
        guard self.delegate == nil else {
            self.delegate!.locationManager(didUpdateLocation: lastLocation)
            return
        }
        // Call the allowDeferredLocationUpdatesUntilTraveled:timeout: method whenever possible to defer the delivery of updates until a later time, as described in Deferring Location Updates While Your App Is in the Background.
//        locationManager.allowDeferredLocationUpdates(untilTraveled: <#T##CLLocationDistance#>, timeout: <#T##TimeInterval#>)
        
    }
        
    // When the location manager pauses location updates, it notifies its delegate object by calling its locationManagerDidPauseLocationUpdates: method. When the location manager resumes updates, it calls the delegate’s locationManagerDidResumeLocationUpdates: method. You can use these delegate methods to perform tasks or adjust the behavior of your app. For example, when location updates are paused, you might use the delegate notification to save data to disk or stop location updates altogether. A navigation app in the middle of turn-by-turn directions might prompt the user and ask whether navigation should be disabled temporarily.
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
}



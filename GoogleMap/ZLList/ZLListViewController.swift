//
//  ZLListViewController.swift
//  GoogleMap
//
//  Created by 余辉 on 2018/11/28.
//  Copyright © 2018年 Zilly. All rights reserved.
//

import UIKit
import GoogleMaps

private let trackCellReusedIdentifier = "trackCellReusedIdentifier"

private let kPathDocument = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
private let kAllDataPath = "\(kPathDocument)/allData.plist"

class ZLListViewController: UIViewController {
    
    lazy var tableView : UITableView = {
        let tableView = UITableView.init(frame: self.view.frame, style: UITableView.Style.grouped)
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "ZLListCell", bundle: nil), forCellReuseIdentifier: trackCellReusedIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var locations = [ZLTrackModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var recordArray = [[String: Any]]()
    var isRecording: Bool = false
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "开始", style: .plain, target: self, action: #selector(beginRecorder))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "结束", style: .plain, target: self, action: #selector(endRecorder))
        
        // 更新title
        NotificationCenter.default.addObserver(self, selector: #selector(updateTitle(_:)), name: NSNotification.Name(rawValue: "updateLocation"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "insertNodeSuccess"), object: nil)
        
        let zldata =  ZLDataManager.init()
        guard let los = zldata.selectData() as? [ZLTrackModel] else { return }
        locations = los
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        for index in 1...5 {
//
//            let zldata =  ZLDataManager.init()
//            let s =  CLLocation.init(latitude: 100.0, longitude: 120.1)
//            let e =  CLLocation.init(latitude: 100.1, longitude: 120.2)
//            let start = ZLLocation.init(location: s, zlIdentify: ZLIdentify.human)
//            let end = ZLLocation.init(location: e, zlIdentify: ZLIdentify.human)
//            let array = [start,end,start,end,start,end,start,end]
//            zldata.insertData(start, end, array)
//
//        }
    }
    
    @objc func refresh() {
        
        let zldata =  ZLDataManager.init()
        guard let los = zldata.selectData() as? [ZLTrackModel] else { return }
        locations = los

        print("------------")
    }
    
    @objc func updateTitle(_ info: Notification) {
        guard let userinfo = info.userInfo else {
            return
        }
        guard let a = userinfo["latitude"] as? Double else {
            return
        }
        guard let b = userinfo["longitude"] as? Double else {
            return
        }
        
        let latStr = String(format: "%.5f", a)
        
        let lonStr = String(format: "%.5f", b)
        
        title = "\(latStr) + \(lonStr)"
        
        if isRecording {
            recordArray.append(["latitude":a,"longitude":b])
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension ZLListViewController : UITableViewDelegate,UITableViewDataSource{
    // MARK:UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: trackCellReusedIdentifier, for: indexPath) as! ZLListCell
        cell.model = locations[indexPath.row]
        return cell
    }
    // MARK:UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}



extension ZLListViewController {
    
    @objc func beginRecorder() {
        isRecording = true
    }
    
    @objc func endRecorder() {
        isRecording = false
        
        print(recordArray)
        
        if let allArray = NSArray(contentsOfFile: kAllDataPath) {
            let tempArray = allArray.addingObjects(from: recordArray) as NSArray
            print("存入\(tempArray.write(toFile: kAllDataPath, atomically: true))成功")
        } else {
            var allArray = NSArray()
            allArray = allArray.addingObjects(from: recordArray) as NSArray
            print("存入\(allArray.write(toFile: kAllDataPath, atomically: true))成功")
        }
        
        recordArray.removeAll()
        print(kPathDocument)
    }
}

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
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)

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

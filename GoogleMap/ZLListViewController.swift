//
//  ZLListViewController.swift
//  GoogleMap
//
//  Created by 余辉 on 2018/11/28.
//  Copyright © 2018年 Zilly. All rights reserved.
//

import UIKit

class ZLListViewController: UIViewController {
    let trackCellReusedIdentifier = "trackCellReusedIdentifier"
    
    lazy var tabelView : UITableView = {
        let tabelView = UITableView.init(frame: self.view.frame, style: UITableView.Style.grouped)
        tabelView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tabelView.register(ZLTrackTableViewCell.classForCoder(), forCellReuseIdentifier: trackCellReusedIdentifier)
        
        return tabelView
    }()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabelView.delegate = self
        tabelView.dataSource = self
        self.view.addSubview(tabelView)
    }
    
}

extension ZLListViewController : UITableViewDelegate,UITableViewDataSource{
    // MARK:UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ZLTrackTableViewCell = tabelView.dequeueReusableCell(withIdentifier: trackCellReusedIdentifier, for: indexPath) as! ZLTrackTableViewCell
        
        cell.backgroundColor = UIColor.lightGray
        return cell
    }
    // MARK:UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}

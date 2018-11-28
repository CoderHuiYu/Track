//
//  ZLListViewController.swift
//  GoogleMap
//
//  Created by 余辉 on 2018/11/28.
//  Copyright © 2018年 Zilly. All rights reserved.
//

import UIKit

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
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }
    
}

extension ZLListViewController : UITableViewDelegate,UITableViewDataSource{
    // MARK:UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: trackCellReusedIdentifier, for: indexPath) as! ZLListCell
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
        return 220
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
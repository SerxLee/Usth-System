
//
//  USSubjectResultTableView.swift
//  Usth System
//
//  Created by Serx on 2017/5/20.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import MJRefresh

enum ResultType {
    case passing
    case semester
    case fail
}

enum CellType {
    case simple
    case detail
}

private let subjectResultTableCellIdentifier: String = "subjectResultTableCellIdentifier"
private let subjectResultDetailTableCellIdentifier: String = "subjectResultDetailTableCellIdentifier"


@objc protocol USSubjectResultTableViewDelegate: NSObjectProtocol {
    
    func subjectResultTableViewDidSelecteCell(subject: USSubject)
    func subjectResultTableViewHeaderRefreshing()
    
}

class USSubjectResultTableView: UIView, UITableViewDataSource, UITableViewDelegate, CYLTableViewPlaceHolderDelegate, USPlaceHolderViewDelegate {

    private var data: USErrorAndData?
    
    weak var delegate: USSubjectResultTableViewDelegate?
    var tableViewType: ResultType?
    
    private var cellType: CellType = .simple
    private var _tableView: UITableView?
    private var _placeHolderView: USPlaceHolderView?
    

    //MARK: - ------Life Circle------
    init() {
        super.init(frame: CGRect.zero)
    }
    
    convenience init(tableViewType: ResultType , data: USErrorAndData?) {
        self.init()
        self.tableViewType = tableViewType
        self.data = data
        self.addSubview(self.tableView!)
        self.layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - ------Methods------
    func layoutPageSubviews() {
        self.tableView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
    }
    
    func startRefresh() {
        if !self.tableView!.mj_header.isRefreshing() {
            self.tableView!.mj_header.beginRefreshing()
        }
    }
    
    func endRefreshing() {
        if (self.tableView!.mj_header.isRefreshing()) {
            self.tableView!.mj_header.endRefreshing()
        }
        if (self.tableView!.mj_footer != nil && self.tableView!.mj_footer.isRefreshing()) {
            self.tableView!.mj_footer.endRefreshing()
        }
    }
    
    func reloadTableWithData(_ data: USErrorAndData?) {
        self.data = data
        self.tableView?.cyl_reloadData()
    }
    
    func changeTableViewCellType(_ cellType: CellType) {
        if cellType == self.cellType {
            return
        } else {
            self.cellType = cellType
            if (cellType == .simple) {
                self.tableView?.rowHeight = 40.0
            } else {
                self.tableView?.rowHeight = 100.0
            }
            self.tableView?.cyl_reloadData()
        }
    }
    //MARK: - ------Delegate View------
    func reloadBtnAction() {
        self.startRefresh()
    }
    
    //MARK: - ------Delegate Model------
    
    //MARK: - ------Delegate Table------
    func numberOfSections(in tableView: UITableView) -> Int {
        if (self.data != nil) {
            if (data?.semesterArr != nil) {
                let semesterArr = self.data!.semesterArr
                var semesterCount = semesterArr!.count
                for i in 0..<semesterArr!.count {
                    let semester: USSemester? = semesterArr![i] as? USSemester
                    if (semester != nil && semester!.subjectArr.count == 0) {
                        semesterCount -= 1
                    }
                }
                return semesterCount
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.data != nil) {
            let semesterArr = self.data!.semesterArr
            let semester: USSemester? = semesterArr![section] as? USSemester
            if (semester != nil) {
                return semester!.subjectArr.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tempCell: UITableViewCell = UITableViewCell()
        
        let semesterArr = self.data!.semesterArr
        let semester: USSemester? = semesterArr![indexPath.section] as? USSemester
        if (semester != nil) {
            let subject: USSubject? = semester!.subjectArr[indexPath.row] as? USSubject
            if (subject != nil) {
                if (self.cellType == .simple) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: subjectResultTableCellIdentifier) as! USSubjectResultTableViewCell
                    cell.classNameLab?.text = subject!.name
                    cell.scoreLab?.text = String(format: "%d", subject!.score.intValue)
                    tempCell = cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: subjectResultDetailTableCellIdentifier) as! USSubjectResultDetailTableViewCell
                    cell.classNameLab?.text = subject!.name
                    
                    let scoreStr = String(format: "%d", subject!.score.intValue)
                    cell.scoreLab?.text = scoreStr
                    cell.classIdLab?.text = "课程编号：" + subject!.subjectId
                    cell.creditLab?.text = "学分：" + String(format: "%d", subject!.credit.intValue)
                    cell.typeLab?.text = "课程类型：" + subject!.type
                    tempCell = cell
                }
            }
        }
        return tempCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (self.data != nil) {
            let semesterArr = self.data!.semesterArr
            let semester: USSemester? = semesterArr![section] as? USSemester
            if (semester != nil) {
                return semester!.semesterName
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let semesterArr = self.data!.semesterArr
        let semester: USSemester? = semesterArr![indexPath.section] as? USSemester
        if (semester != nil) {
            let subject: USSubject? = semester!.subjectArr[indexPath.row] as? USSubject
            if (subject != nil) {
                self.delegate?.subjectResultTableViewDidSelecteCell(subject: subject!)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - ------Delegate Other------
    func makePlaceHolderView() -> UIView! {
        let wifi: Reachability = Reachability.forLocalWiFi()
        let conn: Reachability = Reachability.forInternetConnection()
        if (wifi.currentReachabilityStatus() != NotReachable || conn.currentReachabilityStatus() != NotReachable) {
            self.placeHolderView!.loadPlaceHolderView(with: "没有成绩", and: PlaceHolderViewType.NotData)
        }
        else {
            self.placeHolderView!.loadPlaceHolderView(with: "数据加载失败\n请确保你的手机已经联网", and: PlaceHolderViewType.NotNetwork)
        }
        return self.placeHolderView!
    }
    
    //MARK: - ------Event Response------
    
    func headerRefreshing() -> Void {
        self.delegate?.subjectResultTableViewHeaderRefreshing()
    }
    
    //MARK: - ------Getters and Setters------
    var tableView: UITableView? {
        get {
            if (_tableView != nil) {
                return _tableView
            }
            let tableV = UITableView()
            tableV.register(USSubjectResultTableViewCell.self, forCellReuseIdentifier: subjectResultTableCellIdentifier)
            tableV.register(USSubjectResultDetailTableViewCell.self, forCellReuseIdentifier: subjectResultDetailTableCellIdentifier)
            tableV.delegate = self
            tableV.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.headerRefreshing))
            tableV.dataSource = self
            tableV.rowHeight = 40.0
            tableV.separatorStyle = .none
            tableV.tableFooterView = UIView()
            _tableView = tableV
            return _tableView
        }
        set {
            _tableView = newValue
        }
    }
    
    var placeHolderView: USPlaceHolderView? {
        get {
            if _placeHolderView != nil {
                return _placeHolderView
            }
            let view = USPlaceHolderView()
            view.delegate = self
            
            _placeHolderView = view
            return _placeHolderView
        }
    }
    //MARK: - ------Serialize and Deserialize------


}

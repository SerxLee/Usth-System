//
//  USSubjectResultTableViewController.swift
//  Usth System
//
//  Created by Serx on 2017/5/20.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit


class USSubjectResultTableViewController: UIViewController, USSubjectResultTableViewDelegate, USErrorAndDataDelegate {
    
    private var _subjectResultTabelView: USSubjectResultTableView?
    
    private var _subjectResultModel: USErrorAndData?
    private var subjectResultData: USErrorAndData?
    
    var tableViewType: ResultType!
    
    //MARK: - ------Life Circle------
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(_ tableViewType: ResultType) {
        self.init()
        self.tableViewType = tableViewType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //获取缓存成绩数据
        self.subjectResultData = USErrorAndData.getStoreSubjectResult(withType: self.getTypeStr())
        self.view.addSubview(self.subjectResultTabelView!)
        self.layoutPageSubviews()
        self.getSubjectResultData()
    }
    
    //MARK: - ------Methods------
    func layoutPageSubviews() {
        self.subjectResultTabelView!.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    func getSubjectResultData() {
        let userName: String = UserDefaults.standard.object(forKey: "userName") as! String
        let password: String = UserDefaults.standard.object(forKey: "password") as! String

        let dictionary: NSDictionary = ["type": self.getTypeStr(), "username": userName, "password": password]
        self.subjectResultModel!.getWith(dictionary as! [AnyHashable : Any])
    }
    
    func getTypeStr() -> String {
        if (tableViewType == .passing) {
            return "passing"
        } else if (tableViewType == .semester) {
            return "semester"
        } else if (tableViewType == .fail){
            return "fail"
        }
        return ""
    }
    //MARK: - ------Delegate View------
    func subjectResultTableViewDidSelecteCell(subject: USSubject) {
        let commentVC = USCommentViewController.init(classId: subject.name, isPublic: false)
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    func subjectResultTableViewHeaderRefreshing() {
        self.getSubjectResultData()
    }
    //MARK: - ------Delegate Model------
    func getDataSuccess(_ data: USErrorAndData!) {
        self.subjectResultTabelView?.endRefreshing()
        self.subjectResultTabelView!.reloadTableWithData(data)
        self.subjectResultData = data
        data?.storeSubjectResult(withType: self.getTypeStr())
    }
    
    func getDataWithError(_ error: USError!) {
        self.subjectResultTabelView?.endRefreshing()
        self.subjectResultTabelView!.reloadTableWithData(self.subjectResultData)
    }
    //MARK: - ------Delegate Table------

    //MARK: - ------Delegate Other------
    
    //MARK: - ------Event Response------
    
    //MARK: - ------Getters and Setters------
    var subjectResultTabelView: USSubjectResultTableView? {
        get {
            if (_subjectResultTabelView != nil) {
                return _subjectResultTabelView
            }
            let resultTableView = USSubjectResultTableView.init(tableViewType: self.tableViewType, data: self.subjectResultData)
            resultTableView.delegate = self
            _subjectResultTabelView = resultTableView
            return _subjectResultTabelView
        }
    }

    var subjectResultModel: USErrorAndData? {
        get {
            if (_subjectResultModel != nil) {
                return _subjectResultModel
            }
            let model = USErrorAndData()
            model.delegate = self
            _subjectResultModel = model
            return _subjectResultModel
        }
        set {
            _subjectResultModel = newValue
        }
    }

    //MARK: - ------Serialize and Deserialize------
    
}

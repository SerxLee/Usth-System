//
//  USHomeViewController.swift
//  Usth System
//
//  Created by Serx on 2017/5/23.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit
import MBProgressHUD

class USHomeViewController: UIViewController, USCommentDelegate, USHomeViewDelegate, USErrorAndDataDelegate {
    
    private var _homeView: USHomeView?
    
    private var _comment: USComment?
    private var _subjectResultModel: USErrorAndData?

    
    private var commentsModel: USComment?
    
    //MARK: - ------Life Circle------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.homeView!)
        self.layoutPageSubviews()
        self.getHistoryComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    //MARK: - ------Methods------
    func layoutPageSubviews() {
        self.homeView!.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
            make.top.equalTo(self.view).offset(-20.0)
        }
    }
    
    func getHistoryComments() {
        let myInfo: USMyInfo = USMyInfo.getStoredUser()
        self.comment!.getHistoryComments(withStuId: myInfo.stu_id)
    }
    //MARK: - ------Delegate View------
    func homeViewRefreshHistoryComment() {
        self.getHistoryComments()
    }
    
    func homeViewMoreHistoryCommentBtnDidClick() {
        let historyCommentVC = USHistoryCommentViewController.init(self.commentsModel!)
        self.navigationController?.pushViewController(historyCommentVC, animated: true)
    }
    
    func homeViewPublishBtnDidClick() {
        let commentVC = USCommentViewController.init(classId: "综合交流区", isPublic: true)
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    func homeViewSearchBtnDidClick() {
        let subjectModel = USErrorAndData.getStoreSubjectResult(withType: "passing")
        let searchVC = USSearchViewController.init(subjectData: subjectModel)
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func homeViewHistoryCellDidSelected(_ comment: USComment) {
        let commentVC = USCommentViewController.init(classId: comment.className, isPublic: false)
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    func loginServer() {
        let userName: String = UserDefaults.standard.object(forKey: "userName") as! String
        let password: String = UserDefaults.standard.object(forKey: "password") as! String
        let dictionary: NSDictionary = ["type": "passing", "username": userName, "password": password]
        self.subjectResultModel!.getWith(dictionary as! [AnyHashable : Any])
    }
    
    //MARK: - ------Delegate Model------
    func getHistoryCommentsSuccess(_ comment: USComment!) {
        self.commentsModel = comment
        self.homeView!.reloadHistoyCommentView(data: comment)
    }
    func getHistoryCommentsWithError(_ error: USError!) {
        if (error.code == Int(USErrorType.auth.rawValue)) {
            self.loginServer()
        }
    }
    
    func getDataSuccess(_ data: USErrorAndData!) {
        self.getHistoryComments()
    }
    func getDataWithError(_ error: USError!) {
        //show err
    }
    //MARK: - ------Delegate Table------
    
    //MARK: - ------Delegate Other------
    
    //MARK: - ------Event Response------
    
    //MARK: - ------Getters and Setters------
    var homeView: USHomeView? {
        get {
            if (_homeView != nil ) {
                return _homeView
            }
            let homeV = USHomeView()
            homeV.delegate = self
            _homeView = homeV
            return _homeView
        }
    }
    
    var comment: USComment? {
        get {
            if (_comment != nil) {
                return _comment
            }
            let temp = USComment()
            temp.delegate = self

            _comment = temp
            return _comment
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
    }
    //MARK: - ------Serialize and Deserialize------

}

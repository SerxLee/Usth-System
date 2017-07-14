//
//  USLoginViewController.swift
//  Usth System
//
//  Created by Serx on 2017/5/19.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit
import MBProgressHUD

class USLoginViewController: UIViewController, USLoginViewDelegate, USErrorAndDataDelegate {

    private var _loginView: USLoginView?
    private var _subjectResultModel: USErrorAndData?
    
    private var loginHistory: USLoginHistory!
    private var userName: String?
    private var password: String?
    private var hudWait: MBProgressHUD?
    
    //MARK: - ------Life Circle------
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(temple: String) {
        self.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginHistory = USLoginHistory.getStore()
        self.view.addSubview(self.loginView!)
        self.layoutPageSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: - ------Methods------
    func layoutPageSubviews() {
        self.loginView!.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
    }

    func storeLoginRecord() {
        var recordArr: Array<USLoginHistory> = []
        if self.loginHistory == nil {
            self.loginHistory = USLoginHistory()
        } else {
            if self.loginHistory.recordArr != nil {
                recordArr = self.loginHistory.recordArr as! Array<USLoginHistory>
                for i in 0..<recordArr.count {
                    let record = recordArr[i]
                    if record.userNameStr == self.userName && record.passwordStr == self.password {
                        return
                    }
                }
            }
        }
        let tempRecord = USLoginHistory()
        tempRecord.userNameStr = self.userName
        tempRecord.passwordStr = self.password
        recordArr.append(tempRecord)
        self.loginHistory.recordArr = recordArr
        self.loginHistory.store()
    }
    
    func deleteLoginRecord(with deleteRecord: USLoginHistory) {
        if self.loginHistory == nil || self.loginHistory.recordArr == nil || self.loginHistory.recordArr.count == 0 {
            return
        }
        var recordArr: Array<USLoginHistory>? = self.loginHistory.recordArr as? Array<USLoginHistory>
        for i in 0..<recordArr!.count {
            let record = recordArr![i]
            if record.userNameStr == deleteRecord.userNameStr {
                recordArr!.remove(at: i)
                break
            }
        }
        recordArr = recordArr?.count == 0 ? nil: recordArr
        self.loginHistory.recordArr = recordArr
        self.loginHistory.store()
        self.loginView?.loginHistoryArr = recordArr
    }
    
    //MARK: - ------Delegate View------
    func loginViewClickConfirmBtn(_ userName: String, password: String) {
//        self.showHint(in: self.view, hint: "正在登录...")
        self.hudWait = MBProgressHUD.init().us_showHUD(addTo: self.view, title: "正在登录...", animated: true)
        self.userName = userName
        self.password = password
        let dictionary: NSDictionary = ["type": "passing", "username": userName, "password": password]
        self.subjectResultModel?.getWith(dictionary as! [AnyHashable : Any])
    }
    
    func loginViewDeleteRecord(with record: USLoginHistory) {
        self.deleteLoginRecord(with: record)
    }
    //MARK: - ------Delegate Model------
    func getDataSuccess(_ data: USErrorAndData!) {
        self.hudWait?.us_hide(with: "登录成功", afterSecond: 1.5)
        UserDefaults.standard.set(true, forKey: "userHasLogin")
        UserDefaults.standard.set(self.userName, forKey: "userName")
        UserDefaults.standard.set(self.password, forKey: "password")
        data?.storeSubjectResult(withType: "passing")
        let myInfo = data?.myInfo
        myInfo?.store()
        self.storeLoginRecord()
        let tabBarVC = USTabBarViewController()
        self.present(tabBarVC, animated: true, completion: nil)
    }
    func getDataWithError(_ error: USError!) {
        let userInfo = error.userInfo
        let message = userInfo[NSLocalizedDescriptionKey]
        self.hudWait?.us_hide(with: message as? String, afterSecond: 1.5)
    }

    //MARK: - ------Delegate Table------
    
    //MARK: - ------Delegate Other------
    
    //MARK: - ------Event Response------
    
    //MARK: - ------Getters and Setters------
    var loginView: USLoginView? {
        get {
            if (_loginView != nil) {
                return _loginView
            }
            var recordArr: Array<Any>? = nil
            if (self.loginHistory != nil && self.loginHistory.recordArr != nil && self.loginHistory.recordArr.count > 0) {
                recordArr = self.loginHistory.recordArr
            }
            let loginV = USLoginView.init(with: recordArr)
            loginV.delegate = self
            _loginView = loginV
            return _loginView
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

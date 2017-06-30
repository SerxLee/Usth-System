//
//  USLoginViewController.swift
//  Usth System
//
//  Created by Serx on 2017/5/19.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit

class USLoginViewController: UIViewController, USLoginViewDelegate, USErrorAndDataDelegate{

    private var _loginView: USLoginView?
    
    private var _subjectResultModel: USErrorAndData?
    
    private var userName: String?
    private var password: String?
    
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
    //MARK: - ------Delegate View------
    func loginViewClickConfirmBtn(_ userName: String, password: String) {
        self.showHint(in: self.view, hint: "正在登录...")
        self.userName = userName
        self.password = password
        let dictionary: NSDictionary = ["type": "passing", "username": userName, "password": password]
        self.subjectResultModel?.getWith(dictionary as! [AnyHashable : Any])
    }
    
    //MARK: - ------Delegate Model------
    func getDataSuccess(_ data: USErrorAndData!) {
        self.hideHud()
        UserDefaults.standard.set(true, forKey: "userHasLogin")
        UserDefaults.standard.set(self.userName, forKey: "userName")
        UserDefaults.standard.set(self.password, forKey: "password")
        data?.storeSubjectResult(withType: "passing")
        let myInfo = data?.myInfo
        myInfo?.store()
        let tabBarVC = USTabBarViewController()
        self.present(tabBarVC, animated: true, completion: nil)
    }
    func getDataWithError(_ error: USError!) {
        let userInfo = error.userInfo
        let message = userInfo[NSLocalizedDescriptionKey]
        self.showHint(in: self.view, hint: message as! String)
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
            let loginV = USLoginView()
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

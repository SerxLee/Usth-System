//
//  USSubjectResultViewController.swift
//  Usth System
//
//  Created by Serx on 2017/5/15.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit


class USSubjectResultViewController: UIViewController, USSubjectResultViewDelegate, USSubjectResultViewPagerControllerDelegate {

    private var _subjectResultView: USSubjectResultView?
    private var _subjectResult: USErrorAndData?
    
    private var _subjectResultPagerViewController: USSubjectResultViewPagerController?
    private var _containerView: UIView?
    
    private var _moreBtn: UIButton?
    private var _moreOperationView: UIView?
    private var _blackView: UIView?
    
    //MARK: - ------Life Circle------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChildViewController(self.subjectResultPagerViewController!)
        //self.view.addSubview(self.subjectResultView!)
        self.view.addSubview(self.containerView!)
        self.view.addSubview(self.moreBtn!)
        self.view.addSubview(self.blackView!)
        self.view.addSubview(self.moreOperationView!)
        self.layoutPageSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.hideBottomHairline()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    //MARK: - ------Methods------
    func layoutPageSubviews() {
        self.containerView!.snp.makeConstraints { (make) in
            make.bottom.right.left.top.equalTo(self.view)
        }
        self.moreBtn!.snp.makeConstraints { (make) in
            make.height.equalTo(35.0)
            make.width.equalTo(45.0)
            make.top.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        
        self.blackView!.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.moreOperationView!.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(20.0)
            make.height.equalTo(80.0)
            make.width.equalTo(100.0)
            make.right.equalTo(self.view).offset(120.0)
        }
    }
    
    func dismissMoreOperationView() {
        self.moreOperationView!.snp.updateConstraints { (make) in
            make.right.equalTo(self.view).offset(120.0)
        }
        UIView.animate(withDuration: 0.25) {
            self.blackView!.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    //MARK: - ------Delegate View------
    
    //MARK: - ------Delegate Model------

    //MARK: - ------Delegate Table------
    
    //MARK: - ------Delegate Other------
    
    //MARK: - ------Event Response------
    func moreBtnDidClick(_ sender: UIButton) {
        self.moreOperationView!.snp.updateConstraints { (make) in
            make.right.equalTo(self.view).offset(-20.0)
        }
        UIView.animate(withDuration: 0.25) {
            self.blackView!.alpha = 1.0
            self.view.layoutIfNeeded()
        }
    }
    
    func blackViewDidTap(_ sender: UIGestureRecognizer) {
        self.dismissMoreOperationView()
    }
    
    func simpleBtnDidClick(_ sender: UIButton) {
        self.dismissMoreOperationView()
        self.subjectResultPagerViewController!.changeCell(CellType.simple)
    }
    
    func detailBtnDidClick(_ sender: UIButton) {
        self.dismissMoreOperationView()
        self.subjectResultPagerViewController!.changeCell(CellType.detail)
    }
    
    //MARK: - ------Getters and Setters------
    var subjectResultPagerViewController: USSubjectResultViewPagerController? {
        get {
            if (_subjectResultPagerViewController != nil) {
                return _subjectResultPagerViewController
            }
            let pagerViewController = USSubjectResultViewPagerController()
            pagerViewController.containerDelegate = self
            _subjectResultPagerViewController = pagerViewController
            return _subjectResultPagerViewController
        }
        set {
            _subjectResultPagerViewController = newValue
        }
    }
    
    var containerView: UIView? {
        get {
            if (_containerView != nil) {
                return _containerView
            }
            _containerView = self.subjectResultPagerViewController!.view
            return _containerView
        }
        set {
            _containerView = newValue
        }
    }

    
    var subjectResultView: USSubjectResultView? {
        get {
            if (_subjectResultView != nil) {
                return _subjectResultView
            }
            let resultView = USSubjectResultView()
            resultView.delegete = self
            resultView.backgroundColor = UIColor.red
            _subjectResultView = resultView
            return _subjectResultView
        }
        set {
            _subjectResultView = newValue
        }
    }
    var subjectResult: USErrorAndData? {
        get {
            if (_subjectResult != nil) {
                return _subjectResult
            }
            let model = USErrorAndData()
            _subjectResult = model
            return _subjectResult
        }
        set {
            _subjectResult = newValue
        }
    }

    var moreBtn: UIButton? {
        get {
            if (_moreBtn != nil) {
                return _moreBtn
            }
            let tempBtn = UIButton.init()
            tempBtn.setTitle("\u{e611}", for: .normal)
            
            tempBtn.titleLabel?.font = UIFont.init(name: "iconfont", size: 22.0)
            tempBtn.setTitleColor(UIColor.black, for: .normal)
            tempBtn.addTarget(self, action: #selector(self.moreBtnDidClick(_:)), for: .touchUpInside)
            
            _moreBtn = tempBtn
            return _moreBtn
        }
    }

    var moreOperationView: UIView? {
        get {
            if (_moreOperationView != nil) {
                return _moreOperationView
            }
            let tempView = UIView.init()
            tempView.backgroundColor = UIColor.white
            tempView.layer.cornerRadius = 8.0
            
            let simpleBtn = UIButton.init()
            let attributeStr = NSMutableAttributedString.init(string: "\u{e890} 普通显示")
            attributeStr.setAttributes([NSFontAttributeName: UIFont.init(name: "iconfont", size: 16.0) as Any], range: NSRange.init(location: 0, length: 1))
            attributeStr.setAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 14.0) as Any], range: NSRange.init(location: 2, length: 4))
            simpleBtn.setAttributedTitle(attributeStr, for: UIControlState.normal)
            simpleBtn.addTarget(self, action: #selector(self.simpleBtnDidClick(_:)), for: .touchUpInside)
            
            let detailBtn = UIButton.init()
            let attributeStr2 = NSMutableAttributedString.init(string: "\u{e88f} 详细显示")
            attributeStr2.setAttributes([NSFontAttributeName: UIFont.init(name: "iconfont", size: 16.0) as Any], range: NSRange.init(location: 0, length: 1))
            attributeStr2.setAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 14.0) as Any], range: NSRange.init(location: 2, length: 4))
            detailBtn.setAttributedTitle(attributeStr2, for: .normal)
            detailBtn.addTarget(self, action: #selector(self.detailBtnDidClick(_:)), for: .touchUpInside)
            
            let lineView = UIView()
            lineView.backgroundColor = UIColor.lineGray()
            tempView.addSubview(lineView)
            
            tempView.addSubview(simpleBtn)
            tempView.addSubview(detailBtn)
            simpleBtn.snp.makeConstraints { (make) in
                make.height.equalTo(40.0)
                make.width.equalTo(80.0)
                make.top.equalTo(tempView)
                make.centerX.equalTo(tempView)
            }
            
            detailBtn.snp.makeConstraints { (make) in
                make.height.equalTo(40.0)
                make.width.equalTo(80.0)
                make.top.equalTo(simpleBtn.snp.bottom)
                make.centerX.equalTo(tempView)
            }
            lineView.snp.makeConstraints { (make) in
                make.height.equalTo(0.5)
                make.left.right.equalTo(tempView)
                make.centerY.equalTo(tempView)
            }
            
            _moreOperationView = tempView
            return _moreOperationView
        }
    }
    var blackView: UIView? {
        get {
            if (_blackView != nil) {
                return _blackView
            }
            let tempView = UIView.init()
            tempView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            tempView.alpha = 0
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.blackViewDidTap(_:)))
            tempView.addGestureRecognizer(tapGesture)
            tempView.isUserInteractionEnabled = true
            _blackView = tempView
            return _blackView
        }
    }
    //MARK: - ------Serialize and Deserialize------


}

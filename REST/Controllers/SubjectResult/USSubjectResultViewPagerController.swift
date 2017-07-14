//
//  USSubjectResultViewPagerController.swift
//  Usth System
//
//  Created by Serx on 2017/5/20.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit

@objc protocol USSubjectResultViewPagerControllerDelegate: NSObjectProtocol {
    
}

class USSubjectResultViewPagerController: ViewPagerController, ViewPagerDelegate, ViewPagerDataSource {
    var containerDelegate: USSubjectResultViewPagerControllerDelegate?
    
    private var _passingTVC: USSubjectResultTableViewController?
    private var _semesterTVC: USSubjectResultTableViewController?
    private var _failTVC: USSubjectResultTableViewController?
    
    private let pagerCount: Int = 3
    
    var tabIndex: Int = 0
    
    //MARK: - ------Life Circle------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        //self.isChildViewController = true
    }
    //MARK: - ------Methods------
    func changeCell(_ cellType: CellType) {
        switch self.tabIndex {
        case 0:
            self.passingTVC!.subjectResultTabelView?.changeTableViewCellType(cellType)
            break
        case 1:
            self.semesterTVC!.subjectResultTabelView?.changeTableViewCellType(cellType)
            break
        default:
            self.failTVC!.subjectResultTabelView?.changeTableViewCellType(cellType)
            break
        }
    }
    
    //MARK: - ------Delegate View------
    
    //MARK: - ------Delegate Model------
    
    //MARK: - ------Delegate Table------
    
    //MARK: - ------Delegate Other------
    func numberOfTabs(forViewPager viewPager: ViewPagerController!) -> UInt {
        return UInt(pagerCount)
    }
    
    func viewPager(_ viewPager: ViewPagerController!, valueFor option: ViewPagerOption, withDefault value: CGFloat) -> CGFloat {
        switch option {
        case .tabWidth:
            return SCREEN_WIDTH / CGFloat(pagerCount) - 15.0
        case .tabHeight:
            return 40.0
        default:
            return value
        }
    }
    
    func viewPager(_ viewPager: ViewPagerController!, colorFor component: ViewPagerComponent, withDefault color: UIColor!) -> UIColor! {
        switch component {
        case .indicator:
            return UIColor.sexBlue()
        case .tabsView:
            return UIColor.white
        default:
            return color
        }
    }
    
    func viewPager(_ viewPager: ViewPagerController!, viewForTabAt index: UInt) -> UIView! {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 14.0)
        switch index {
        case 0:
            label.text = "已通过"
            break
        case 1:
            label.text = "本学期"
            break
        default:
            label.text = "未通过"
            break
        }
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
        label.sizeToFit()
        return label
    }
    
    func viewPager(_ viewPager: ViewPagerController!, contentViewControllerForTabAt index: UInt) -> UIViewController! {
        switch index {
        case 0:
            return passingTVC
            
        case 1:
            return semesterTVC
            
        default:
            return failTVC
            
        }
    }
    
    func viewPager(_ viewPager: ViewPagerController!, didChangeTabTo index: UInt) {
        self.tabIndex = Int(index)
    }
    //MARK: - ------Event Response------
    
    //MARK: - ------Getters and Setters------
    var passingTVC: USSubjectResultTableViewController? {
        get {
            if (_passingTVC != nil) {
                return _passingTVC
            }
            let tableVC = USSubjectResultTableViewController.init(ResultType.passing)
            tableVC.view.backgroundColor = UIColor.red
            _passingTVC = tableVC
            return _passingTVC
        }
        set {
            _passingTVC = newValue
        }
    }
    
    var semesterTVC: USSubjectResultTableViewController? {
        get {
            if (_semesterTVC != nil) {
                return _semesterTVC
            }
            let tableVC = USSubjectResultTableViewController.init(ResultType.semester)
            tableVC.view.backgroundColor = UIColor.brown
            _semesterTVC = tableVC
            return _semesterTVC
        }
        set {
            _semesterTVC = newValue
        }
    }
    
    var failTVC: USSubjectResultTableViewController? {
        get {
            if (_failTVC != nil) {
                return _failTVC
            }
            
            let tableVC = USSubjectResultTableViewController.init(ResultType.fail)
            tableVC.view.backgroundColor = UIColor.blue
            _failTVC = tableVC
            return _failTVC
        }
        set {
            _failTVC = newValue
        }
    }
    //MARK: - ------Serialize and Deserialize------
    
}

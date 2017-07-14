//
//  USHistoryCommentViewController.swift
//  Usth System
//
//  Created by Serx on 2017/6/3.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit

class USHistoryCommentViewController: ViewPagerController, ViewPagerDelegate, ViewPagerDataSource{
    

    var commentData: USComment!
    
    private var _publishCommentVC: USHistoryTableViewController?
    private var _subjectCommentVC: USHistoryTableViewController?
    
    private var publicCommentData: USComment!
    private var subjectCommentData: USComment!
    
    private let pagerCount: Int = 2
    
    //MARK: - ------Life Circle------
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(_ publicCommentData: USComment, subjectCommentData: USComment) {
        self.init()
        self.publicCommentData = publicCommentData
        self.subjectCommentData = subjectCommentData
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        self.title = "评论历史"
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
            return SCREEN_WIDTH / CGFloat(pagerCount)
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
            label.text = "课程板块"
            break
        default:
            label.text = "综合板块"
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
            return self.subjectCommentVC
        default:
            return self.publishCommentVC
        }
    }
    //MARK: - ------Event Response------
    
    //MARK: - ------Getters and Setters------
    var publishCommentVC: USHistoryTableViewController? {
        get {
            if (_publishCommentVC != nil) {
                return _publishCommentVC
            }
            let tableVC = USHistoryTableViewController.init(true, comment: self.publicCommentData)
            _publishCommentVC = tableVC
            return _publishCommentVC
        }
    }
    
    var subjectCommentVC: USHistoryTableViewController? {
        get {
            if (_subjectCommentVC != nil) {
                return _subjectCommentVC
            }
            let tableVC = USHistoryTableViewController.init(false, comment: self.subjectCommentData)
            _subjectCommentVC = tableVC
            return _subjectCommentVC
        }
    }
    
    //MARK: - ------Serialize and Deserialize------

}

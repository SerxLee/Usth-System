//
//  USTabBarViewController.swift
//  Usth System
//
//  Created by Serx on 2017/5/15.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit

public class USTabBarViewController: UITabBarController {
    
    var homeViewController: USHomeViewController!
    var subjectResultViewController: USSubjectResultViewController!
    var analyseViewController: USAnalyseViewController!
    var myInfoViewController: USMyInfoViewController!
    
    var controllers: Array<UIViewController>?
    
    //MARK: - ------Life Circle------
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.layoutPageSubviews()
    }
    
    //MARK: - ------Methods------
    func layoutPageSubviews() {
        self.view.backgroundColor = UIColor.white
        self.addViewControllersToTabBar()
    }
    
    func addViewControllersToTabBar() {
        let homeVC = USHomeViewController()
        homeVC.title = "首页"
        let homeNVC = USNavigationViewController.init(rootViewController: homeVC)
        homeNVC.tabBarItem = UITabBarItem.init(title: "首页", image: UIImage.init(named: "home-page"), selectedImage: UIImage.init(named: "home-pagey"))

        
        let subjectResultVC = USSubjectResultViewController()
//        let tempVC = USSubjectResultViewPagerController()
        let subjectResultNVC = USNavigationViewController.init(rootViewController: subjectResultVC)
        subjectResultVC.title = "课程成绩"
        subjectResultNVC.tabBarItem = UITabBarItem.init(title: "课程成绩", image: UIImage.init(named: "subject"), selectedImage: UIImage.init(named: "subjected"))
        
        let analyseVC = USAnalyseViewController()
        let analyseNVC = USNavigationViewController.init(rootViewController: analyseVC)
        analyseVC.title = "成绩分析"
        analyseNVC.tabBarItem = UITabBarItem.init(title: "成绩分析", image: UIImage.init(named: "strategy-page"), selectedImage: UIImage.init(named: "strategy-pagey"))
        
        let myInfoVC = USMyInfoViewController()
        myInfoVC.tabBarItem = UITabBarItem.init(title: "我的", image: UIImage.init(named: "my-information"), selectedImage: UIImage.init(named: "my-informationy"))
        
        controllers = [homeNVC, subjectResultNVC, analyseNVC, myInfoVC]
        self.setViewControllers(controllers, animated: true)
    }
    //MARK: - ------Delegate View------
    
    //MARK: - ------Delegate Model------
    
    //MARK: - ------Delegate Table------
    
    //MARK: - ------Delegate Other------
    
    //MARK: - ------Event Response------
    
    //MARK: - ------Getters and Setters------
    
    //MARK: - ------Serialize and Deserialize------



    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}

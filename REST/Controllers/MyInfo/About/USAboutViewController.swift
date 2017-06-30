//
//  USAboutViewController.swift
//  Usth System
//
//  Created by Serx on 2017/6/14.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit

class USAboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "关于设计"
        let textView = UITextView.init(frame: self.view.frame)
        self.view.addSubview(textView)
        textView.font = UIFont.systemFont(ofSize: 16.0)
        textView.text = "        本系统通过在服务器模拟登陆指定学校的教务系统，设计并实现一款基于 iOS 的课程成绩查询app。本设计是以 Xcode 8.3 作为开发平台，开发语言选用了苹果新发布的开发语言 Swift 3.0 ，以及已经普及了的 Ojbective-C 2.0，两种语言混合编程开发并充分利用各自的优点，并结合 MySQL 数据库，开发设计出这一款基于iOS的课程成绩查询app。\n        该设计能够让同学们在移动设备上，通过这款app快速查询个人截止当前的考试成绩，查看成绩分析数据，交流平台上互动交流。该app主要是为在读大学生设计，主要的实现的功能是，查询成绩，综合成绩分析的功能，以及评论交流板块中的发布评论、回复评论和点赞等功能。\n\n\n\n开发人员信息：\n\n        黑龙江科技大学\n\n        计算机科学与技术 13-1 班\n\n        李绍享"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

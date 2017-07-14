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
        textView.text = "        通过本应用的服务器模拟登陆指定学校的教务系统，实现成绩的查询功能。接下来会开发更多的功能，比如选课等。"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

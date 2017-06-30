//
//  USHistoryTableViewController.swift
//  Usth System
//
//  Created by Serx on 2017/6/3.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit

class USHistoryTableViewController: UIViewController, USHistoryCommentViewDelegate {

    private var _historyCommentView: USHistoryCommentView?
    
    private var isPusblish: Bool!
    private var commentData: USComment!
    
    private var publicCommentData: USComment = USComment()
    private var subjectCommentData: USComment = USComment()
    
    //MARK: - ------Life Circle------
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(_ isPublish: Bool, comment: USComment) {
        self.init()
        self.isPusblish = isPublish
        self.commentData = comment
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.filterComment()
        self.view.addSubview(self.historyCommentView!)
        self.layoutPageSubviews()
    }
    
    func filterComment() {
        if (self.commentData != nil) {
            let commentsArr = self.commentData.commentsArr
            var publicArr: [USComment] = []
            var SubjectArr: [USComment] = []

            for index in 0..<commentsArr!.count {
                let tempComment: USComment! = commentsArr![index] as! USComment
                if (tempComment.className == "综合交流区") {
                    publicArr.append(tempComment)
                } else {
                    SubjectArr.append(tempComment)
                }
            }
            self.publicCommentData.commentsArr = publicArr
            self.subjectCommentData.commentsArr = SubjectArr
        }
    }
    
    //MARK: - ------Methods------
    func layoutPageSubviews() {
        self.historyCommentView!.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    //MARK: - ------Delegate View------
    func historyCommentViewDidSelected(_ comment: USComment) {
        let commentVC = USCommentViewController.init(classId: comment.className, isPublic: false)
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    //MARK: - ------Delegate Model------
    
    //MARK: - ------Delegate Table------
    var historyCommentView: USHistoryCommentView? {
        get {
            if (_historyCommentView != nil) {
                return _historyCommentView
            }
            let comment: USComment!
            if isPusblish {
                comment = self.publicCommentData
            } else {
                comment = self.subjectCommentData
            }
            let tempView = USHistoryCommentView.init(self.isPusblish, comment: comment)
            tempView.delegate = self
            _historyCommentView = tempView
            return _historyCommentView
        }
    }

    //MARK: - ------Delegate Other------

}

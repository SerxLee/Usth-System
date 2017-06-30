//
//  USHistoryCommentView.swift
//  Usth System
//
//  Created by Serx on 2017/6/3.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit
import AFNetworking
import MJRefresh

protocol USHistoryCommentViewDelegate: NSObjectProtocol {
    func historyCommentViewDidSelected(_ comment: USComment)
}

private let historyCommentsTableCellIdentifier: String = "historyCommentsTableCellIdentifier"

class USHistoryCommentView: UIView ,UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: USHistoryCommentViewDelegate?
    
    private var _tableView: UITableView?
    
    private var isPusblish: Bool!
    private var commentData: USComment!

    //MARK: - ------Life Circle------
    init(_ isPublish: Bool, comment: USComment) {
        self.isPusblish = isPublish
        self.commentData = comment
        super.init(frame: .zero)
        self.addSubview(self.tableView!)
        self.layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ------Methods------
    func layoutPageSubviews() {
        self.tableView!.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    func startRefresh() {
        if !self.tableView!.mj_header.isRefreshing() {
            self.tableView!.mj_header.beginRefreshing()
        }
    }
    
    func endRefreshing() {
        if (self.tableView!.mj_header.isRefreshing()) {
            self.tableView!.mj_header.endRefreshing()
        }
        if (self.tableView!.mj_footer != nil && self.tableView!.mj_footer.isRefreshing()) {
            self.tableView!.mj_footer.endRefreshing()
        }
    }
    
    //MARK: - ------Delegate View------
    
    //MARK: - ------Delegate Model------
    
    //MARK: - ------Delegate Table------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.commentData != nil) {
            let commentsArr = self.commentData!.commentsArr
            if (commentsArr != nil) {
                return commentsArr!.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: historyCommentsTableCellIdentifier, for: indexPath) as! USHomeCommentTableViewCell
        
        let commentsArr = self.commentData!.commentsArr
        let tempComment: USComment! = commentsArr![indexPath.row] as! USComment
        
        if !tempComment.head.isEmpty {
            cell.headerImgView!.setImageWith(URL.init(string: tempComment.head)!, placeholderImage: UIImage.init(named: "Default-Header"))
        } else {
            cell.headerImgView!.image = UIImage.init(named: "Default-Header")
        }
        
        cell.setCommentTextView(authorName: "", commentStr: tempComment.content)
        if (!tempComment.refedContent.isEmpty) {
            cell.replyCommentTextView!.isHidden = false
            cell.setReplyCommentTextView(authorName: tempComment.refedAuthor, commentStr: tempComment.refedContent)
        } else {
            cell.replyCommentTextView!.isHidden = true
        }
        cell.authorNameLab?.text = tempComment.authorName
        if (isPusblish) {
            cell.classNameLab?.isHidden = true
        } else {
            cell.classNameLab?.text = tempComment.className
            cell.classNameLabSizeToFit()
        }
        cell.publishTimeLab?.text = "发布于：" +  NSDate.init(timeIntervalSince1970: Double(tempComment.time)!).fullDescription()
        cell.diggNumLab!.text = String.init(format: "被赞了%d次", tempComment.digg.intValue)
        cell.diggNumLabSizeToFit()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let commentsArr = self.commentData!.commentsArr
        let tempComment: USComment! = commentsArr![indexPath.row] as! USComment
        return USHomeCommentTableViewCell.getCellHeight(commentData: tempComment)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (!self.isPusblish) {
            let commentsArr = self.commentData!.commentsArr
            let tempComment: USComment! = commentsArr![indexPath.row] as! USComment
            self.delegate?.historyCommentViewDidSelected(tempComment)
        }
    }
    //MARK: - ------Delegate Other------
    
    //MARK: - ------Event Response------
    
    //MARK: - ------Getters and Setters------
    var tableView: UITableView? {
        get {
            if (_tableView != nil) {
                return _tableView
            }
            let tableV = UITableView.init()
            tableV.delegate = self
            tableV.dataSource = self
            tableV.tableFooterView = UIView()
            tableV.register(USHomeCommentTableViewCell.self, forCellReuseIdentifier: historyCommentsTableCellIdentifier)
            tableV.separatorStyle = .none
            
            _tableView = tableV
            return _tableView
        }
    }
    //MARK: - ------Serialize and Deserialize------

}

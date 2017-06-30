//
//  USCommentView.swift
//  Usth System
//
//  Created by Serx on 2017/5/28.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit
import AFNetworking
import MJRefresh

private let commentTableCellIdentifier: String = "commentTableCellIdentifier"
private let publicCommentTableCellIdentifier: String = "publicCommentTableCellIdentifier"

protocol USCommentViewDelegate: NSObjectProtocol {
    func commentViewDiggComment(operationComment: USComment)
    func commentViewReplyComment(operationComment: USComment, commentStr: String)
    func commentViewPublishNewComment(commentStr: String)
    func commentViewHeaderToHistoryComments(operationComment: USComment)

    
    func commentViewHeaderRefresh()
    func commentViewFooterRefresh()
}

class USCommentView: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate , USCommentTableViewCellDelegate{
    
    weak var delegete: USCommentViewDelegate?
    
    private var _fakeNavigationBar: UIView?
    private var _leftBtn: UIButton?
    private var _rightBarBtn: UIBarButtonItem?
    
    private var _backImageView: UIImageView?
    private var _headerImageView: UIImageView?
    private var _headerView: UIView?

    private var _tableView: UITableView?
    
    private var _fakeCommentInputFieldAccessoryView: UIView?
    private var _realCommentInputField: UITextField?
    
    private var commentModel: USComment?
    
    private var diggIndexPath: IndexPath!
    private var replyIndexPath: IndexPath!
    private var contentStr: String!
    
    private var isPublishNew: Bool! = false

    private var classId: String!
    
    private var isPublic: Bool!


    // 假评论输入框
    lazy var fakeCommentInputField: UITextField = {
        let fakeTextField = UITextField(frame: .zero)
        fakeTextField.inputAccessoryView = self.fakeCommentInputFieldAccessoryView
        return fakeTextField
    }()
    
    //MARK: - ------Life Circle------
    init(_ classId: String, isPublic: Bool) {
        super.init(frame: .zero)
        self.classId = classId
        self.isPublic = isPublic
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
    
    func reloadCommentListView(withData comments: USComment?, isFooterRefresh: Bool) {
        if (comments != nil) {
            if !isFooterRefresh {
                self.commentModel = comments
                self.tableView?.reloadData()
                self.tableView?.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 1, height: 1), animated: true)
                if (self.tableView!.mj_footer == nil) {
                    self.tableView!.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.footerRefreshing))
                }
            } else {
                var newCommentsArr = self.commentModel!.commentsArr!
                for tempComment in comments!.commentsArr {
                    newCommentsArr.append(tempComment)
                }
                self.commentModel!.commentsArr = newCommentsArr
                self.tableView?.reloadData()
            }
        }
        if (comments == nil || comments!.commentsArr.count <= 20) {
            self.tableView!.mj_footer.state = .noMoreData
        }
    }
    
    func commentFiledResignFirstResponder() {
        if realCommentInputField!.isFirstResponder {
            realCommentInputField!.resignFirstResponder()
        }
        if fakeCommentInputField.isFirstResponder {
            fakeCommentInputField.resignFirstResponder()
        }
    }
    
    func appenNewComment(commentId: String!) {
        let newComment: USComment = USComment()
        var newCommentsArr = self.commentModel!.commentsArr!
        let myInfo: USMyInfo = USMyInfo.getStoredUser()
        if (!isPublishNew) {
            let tempComment: USComment! = newCommentsArr[self.replyIndexPath.row] as! USComment
            newComment.refId = tempComment.commentId
            newComment.refedAuthor = tempComment.authorName
            newComment.refedContent = tempComment.content
            newComment.refedAuthorId = tempComment.stuId
        } else {
            newComment.refId = ""
            newComment.refedAuthor = ""
            newComment.refedContent = ""
            newComment.refedAuthorId = ""
        }
        newComment.commentId = commentId
        newComment.className = self.classId
        newComment.content = self.contentStr
        newComment.stuId = myInfo.stu_id
        newComment.authorName = myInfo.stu_name
        newComment.head = myInfo.stu_header
        newComment.time = String(NSDate().timeIntervalSince1970)
        newComment.digged = 0
        newComment.digg = 0
        newCommentsArr.insert(newComment, at: 0)
        self.commentModel!.commentsArr = newCommentsArr
        self.reloadCommentListView(withData: self.commentModel, isFooterRefresh: false)
    }
    //MARK: - ------Delegate View------
    
    func commentTableViewCell(commentCell: USCommentTableViewCell, didClickDiggBtn: UIButton) {
        self.diggIndexPath = self.tableView!.indexPath(for: commentCell)
        var commentsArr = self.commentModel!.commentsArr
        let tempComment: USComment! = commentsArr![self.diggIndexPath.row] as! USComment
        if (tempComment.digged.intValue != 1) {
        tempComment.digged = 1
        tempComment.digg = tempComment.digg.intValue + 1 as NSNumber
        commentsArr![self.diggIndexPath.row] = tempComment
        self.commentModel!.commentsArr = commentsArr
        self.tableView!.reloadRows(at: [diggIndexPath], with: .none)
        self.delegete?.commentViewDiggComment(operationComment: tempComment)
        }
    }
    
    func commentTableViewCell(commentCell: USCommentTableViewCell, didClickReplyBtn: UIButton) {
        self.replyIndexPath = self.tableView!.indexPath(for: commentCell)
        if fakeCommentInputField.becomeFirstResponder() {
            self.isPublishNew = false
            self.realCommentInputField!.placeholder = ""
            self.realCommentInputField!.becomeFirstResponder()
        }
    }
    
    func commentTableViewCellTapHeader(commentCell: USCommentTableViewCell) {
        let indexPath = self.tableView!.indexPath(for: commentCell)
        var commentsArr = self.commentModel!.commentsArr
        let tempComment: USComment! = commentsArr![indexPath!.row] as! USComment
        self.delegete?.commentViewHeaderToHistoryComments(operationComment: tempComment)
    }
    
    //MARK: - ------Delegate Model------
    
    //MARK: - ------Delegate Table------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.commentModel != nil) {
            return commentModel!.commentsArr.count;
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: commentTableCellIdentifier, for: indexPath) as! USCommentTableViewCell

        cell.delegate = self
        let commentsArr = self.commentModel!.commentsArr
        let tempComment: USComment! = commentsArr![indexPath.row] as! USComment
        
        if !tempComment.head.isEmpty {
            cell.headerImgView!.setImageWith(URL.init(string: tempComment.head)!, placeholderImage: UIImage.init(named: "Default-Header"))
        } else {
            cell.headerImgView!.image = UIImage.init(named: "Default-Header")
        }

        cell.setCommentTextView(authorName: tempComment.authorName, commentStr: tempComment.content)
        if (!tempComment.refedContent.isEmpty) {
            cell.replyCommentTextView!.isHidden = false
            cell.setReplyCommentTextView(authorName: tempComment.refedAuthor, commentStr: tempComment.refedContent)
        } else {
            cell.replyCommentTextView!.isHidden = true
        }
        cell.publishTimeLab?.text = NSDate.init(timeIntervalSince1970: Double(tempComment.time)!).fullDescription()
        if (tempComment.digged.intValue == 1) {
            let redheart = UIImage(named: "redHeart")
            cell.diggBtn!.setImage(redheart, for: UIControlState.normal)
        } else {
            let blackheart = UIImage(named: "blackHeart")
            cell.diggBtn!.setImage(blackheart, for: UIControlState.normal)
        }
        cell.diggNumLab!.text = String(tempComment.digg.intValue)
        cell.diggNumLabSizeToFit()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let commentsArr = self.commentModel!.commentsArr
        let tempComment: USComment! = commentsArr![indexPath.row] as! USComment
        return USCommentTableViewCell.getCellHeight(commentData: tempComment)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.commentFiledResignFirstResponder()
    }
    //MARK: - ------Delegate Other------
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == realCommentInputField) {
            self.contentStr = textField.text!
            if (isPublishNew!) {
                self.delegete?.commentViewPublishNewComment(commentStr: self.contentStr)
            } else {
                let commentsArr = self.commentModel!.commentsArr
                let tempComment: USComment! = commentsArr![self.replyIndexPath.row] as! USComment
                self.delegete?.commentViewReplyComment(operationComment: tempComment, commentStr: self.contentStr)
            }
        }
        textField.text = ""
        return true
    }
    
    //MARK: - ------Event Response------
    func rightBarItemAction(sender: AnyObject) {
        //TODO: edit a new comment
        if fakeCommentInputField.becomeFirstResponder() {
            self.isPublishNew = true
            self.realCommentInputField!.placeholder = ""
            self.realCommentInputField!.becomeFirstResponder()
        }
    }

    func headerRefreshing() -> Void {
        self.delegete?.commentViewHeaderRefresh()
    }
    
    func footerRefreshing() -> Void  {
        self.delegete?.commentViewFooterRefresh()
    }
    //MARK: - ------Getters and Setters------
    var fakeNavigationBar: UIView? {
        get {
            if (_fakeNavigationBar != nil) {
                return _fakeNavigationBar
            }
            let barView = UIView()
            
            _fakeNavigationBar = barView
            return _fakeNavigationBar
        }
    }
    
    var tableView: UITableView? {
        get {
            if (_tableView != nil) {
                return _tableView
            }
            let tableV = UITableView()
            tableV.register(USCommentTableViewCell.self, forCellReuseIdentifier: commentTableCellIdentifier)

            tableV.delegate = self
            tableV.dataSource = self
            tableV.allowsSelection = false
            tableV.tableFooterView = UIView()
            tableV.separatorStyle = .none
            tableV.addSubview(self.fakeCommentInputField)
            tableV.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.headerRefreshing))
            _tableView = tableV
            return _tableView
        }
    }
    
    var fakeCommentInputFieldAccessoryView: UIView? {
        get {
            if (_fakeCommentInputFieldAccessoryView != nil) {
                return _fakeCommentInputFieldAccessoryView
            }
            let commentInputFieldAccessoryView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 44.0))
            commentInputFieldAccessoryView.backgroundColor = UIColor(white: 0.91, alpha: 1)
            commentInputFieldAccessoryView.addSubview(self.realCommentInputField!)
            
            self.realCommentInputField!.translatesAutoresizingMaskIntoConstraints = false
            
            commentInputFieldAccessoryView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"H:|-8-[commentTextField]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["commentTextField" : self.realCommentInputField!]))
            commentInputFieldAccessoryView.addConstraint(NSLayoutConstraint(item: self.realCommentInputField!, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: commentInputFieldAccessoryView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))

            _fakeCommentInputFieldAccessoryView = commentInputFieldAccessoryView
            return _fakeCommentInputFieldAccessoryView
        }
    }
    
    var realCommentInputField: UITextField? {
        get {
            if (_realCommentInputField != nil) {
                return _realCommentInputField
            }
            let commentInputField = UITextField()
            commentInputField.delegate = self
            commentInputField.returnKeyType = UIReturnKeyType.send;
            commentInputField.spellCheckingType = UITextSpellCheckingType.no
            commentInputField.autocorrectionType = UITextAutocorrectionType.no
            commentInputField.borderStyle = UITextBorderStyle.roundedRect
            
            _realCommentInputField = commentInputField
            return _realCommentInputField
        }
    }
    
    var rightBarBtn: UIBarButtonItem? {
        get {
            if (_rightBarBtn != nil) {
                return _rightBarBtn
            }
            let barBtn = UIBarButtonItem.init(image: UIImage.init(named: "edit"), style: .plain, target: self, action: #selector(self.rightBarItemAction(sender:)))
            barBtn.tintColor = UIColor.white
            
            _rightBarBtn = barBtn
            return _rightBarBtn
        }
    }
    
    var headerView: UIView? {
        get {
            if (_headerView != nil) {
                return _headerView
            }
            let headerV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 200))
            headerV.backgroundColor = UIColor.red
            
            _headerView = headerV
            return _headerView
        }
    }


    //MARK: - ------Serialize and Deserialize------

}

//
//  USCommentViewController.swift
//  Usth System
//
//  Created by Serx on 2017/5/28.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit

enum OperationType {
    case None
    case Digg
    case Reply
    case Public
}


class USCommentViewController: UIViewController, USCommentDelegate, USCommentViewDelegate, USErrorAndDataDelegate {

    private var _comment: USComment?
    private var _subjectResultModel: USErrorAndData?

    private var _commentView: USCommentView?
    

    private var operation: OperationType = .None
    private var operationComment: USComment?
    private var commentStr: String?

    
    private var classId: String!
    private var isPublic: Bool!

    //MARK: - ------Life Circle------
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(classId: String!, isPublic: Bool) {
        self.init()
        self.classId = classId
        self.isPublic = isPublic
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.commentView!)
        self.layoutPageSubviews()
        self.commentView!.startRefresh()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = self.commentView!.rightBarBtn
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        self.title = self.classId
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    //MARK: - ------Methods------
    func layoutPageSubviews() {
        self.commentView!.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    func loginServer() {
        let userName: String = UserDefaults.standard.object(forKey: "userName") as! String
        let password: String = UserDefaults.standard.object(forKey: "password") as! String
        let dictionary: NSDictionary = ["type": "passing", "username": userName, "password": password]
        self.subjectResultModel!.getWith(dictionary as! [AnyHashable : Any])
    }
    
    func handleRequestError(_ error: USError) {
        if (error.code == Int(USErrorType.auth.rawValue)) {
            self.loginServer()
            return
        }
        
        if (self.operation == .Digg) {
            self.commentView?.changeDiggStateAfterError()
        }
        self.showHint(in: self.view, hint: error.errorMessage())
    }
    

    //MARK: - ------Delegate View------
    func commentViewReplyComment(operationComment: USComment, commentStr: String) {
        if commentStr == "" {
            let alert = UIAlertController(title: nil, message: "请输入评论内容", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: { (nil) in
                if self.commentView!.fakeCommentInputField.becomeFirstResponder() {
                    self.commentView!.realCommentInputField!.becomeFirstResponder()
                }
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            self.showHint(in: self.view, hint: "正在回复...")
            self.operation = .Reply
            self.operationComment = operationComment
            self.commentStr = commentStr
            let parameters: Dictionary = ["content": commentStr]
            self.comment?.reply(withParameters: parameters, andClassId: operationComment.className, andRefId: operationComment.commentId)
            self.commentView!.commentFiledResignFirstResponder()
        }
    }
    
    func commentViewDiggComment(operationComment: USComment) {
        self.operationComment = operationComment
        self.operation = .Digg
        self.comment!.diggComment(withCommentId: operationComment.commentId)
    }
    
    func commentViewHeaderRefresh() {
        self.comment!.getCommentsWithClassId(self.classId)
    }
    
    func commentViewFooterRefresh() {
        self.comment!.getNextPageComments()
    }
    
    func commentViewPublishNewComment(commentStr: String) {
        if commentStr == "" {
            let alert = UIAlertController(title: nil, message: "请输入评论内容", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: { (nil) in
                if self.commentView!.fakeCommentInputField.becomeFirstResponder() {
                    self.commentView!.realCommentInputField!.becomeFirstResponder()
                }
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            self.showHint(in: self.view, hint: "正在发布新评论...")
            self.operation = .Public
            self.commentStr = commentStr
            let parameters: Dictionary = ["content": commentStr]
            self.comment?.publishNewComment(withParameters: parameters, andClassId: self.classId)
            self.commentView!.commentFiledResignFirstResponder()
        }
    }
    
    func commentViewHeaderToHistoryComments(operationComment: USComment) {
        self.showHint(in: self.view, hint: "等待获取数据...")
        self.comment!.getHistoryComments(withStuId: operationComment.stuId)
    }
    //MARK: - ------Delegate Model------
    func getDataSuccess(_ data: USErrorAndData!) {
        //TODO: 完善
        switch self.operation {
        case .Digg:
            self.commentViewDiggComment(operationComment: self.operationComment!)
            break
        case .Public:
            self.commentViewPublishNewComment(commentStr: self.commentStr!)
            break
        case .Reply:
            self.commentViewReplyComment(operationComment: self.operationComment!, commentStr: self.commentStr!)
            break
        default:
            break
        }
    }
    func getDataWithError(_ error: USError!) {
        //show err
        self.showHint(in: self.view, hint: error.errorMessage())
    }
    
    func getCommentsSuccess(_ comment: USComment!) {
        if (comment.errCode == 0) {
            self.commentView!.reloadCommentListView(withData: comment, isFooterRefresh: false)
            self.commentView!.endRefreshing()
        } else {
            //handle server error
        }
    }
    func getCommentsWithError(_ error: USError!) {
        self.showHint(in: self.view, hint: error.errorMessage())
    }
    
    func replyCommentSuccess(_ comment: USComment!) {
        self.hideHud()
        self.showHint(in: self.view, hint: "回复成功！")
        self.commentView!.appenNewComment(commentId: comment.commentId)
    }
    func replyCommentWithError(_ error: USError!) {
        self.handleRequestError(error)
    }
    
    func publishCommentSuccess(_ comment: USComment!) {
        self.hideHud()
        self.showHint(in: self.view, hint: "发布新评论成功！")
        self.commentView!.appenNewComment(commentId: comment.commentId)
    }
    func publishCommentsWithError(_ error: USError!) {
        self.handleRequestError(error)
    }
    
    func diggCommentSuccess(_ comment: USComment!) {
        
    }
    func diggCommentWithError(_ error: USError!) {
        self.handleRequestError(error)
    }
    
    func getNextPageCommentsSuccess(_ comment: USComment!) {
        if (comment.errCode == 0) {
            self.commentView!.reloadCommentListView(withData: comment, isFooterRefresh: true)
            self.commentView!.endRefreshing()
        } else {
            //handle server error
        }
    }
    func getNextPageCommentsWithError(_ error: USError!) {
        self.showHint(in: self.view, hint: error.errorMessage())
    }
    
    func getHistoryCommentsSuccess(_ comment: USComment!) {
        self.hideHud()
        if (comment.errCode != -1) {
            let historyCommentVC = USHistoryCommentViewController.init(comment)
            self.navigationController?.pushViewController(historyCommentVC, animated: true)
        }
    }
    func getHistoryCommentsWithError(_ error: USError!) {
        self.hideHud()
        self.showHint(in: self.view, hint: error.errorMessage())
    }
    //MARK: - ------Delegate Table------
    
    //MARK: - ------Delegate Other------
    
    //MARK: - ------Event Response------
    
    //MARK: - ------Getters and Setters------
    var comment: USComment? {
        get {
            if (_comment != nil) {
                return _comment
            }
            let request = USComment()
            request.delegate = self
            
            _comment = request
            return _comment
        }
    }
    
    var commentView: USCommentView? {
        get {
            if (_commentView != nil) {
                return _commentView
            }
            let view = USCommentView.init(self.classId, isPublic: self.isPublic)
            view.delegete = self
            
            _commentView = view
            return _commentView
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

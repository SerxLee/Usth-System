//
//  USHomeView.swift
//  Usth System
//
//  Created by Serx on 2017/5/23.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol USHomeViewDelegate: NSObjectProtocol {
    func homeViewRefreshHistoryComment()
    func homeViewMoreHistoryCommentBtnDidClick()
    func homeViewPublishBtnDidClick()
    func homeViewSearchBtnDidClick()
    func homeViewHistoryCellDidSelected(_ comment: USComment)
}

let historyCommentTableCellIdentifier: String = "historyCommentTableCellIdentifier"
let btnViewHeight: CGFloat = (SCREEN_WIDTH - (3 + 1) * 20) / 3.0

class USHomeView: UIView , UITableViewDelegate, UITableViewDataSource {
    private var _scrollView: UIScrollView?
    private var _containerView: UIView?
    private var _searchBarView: UIView?
    private var _headerView: UIView?
    private var _bodyView: UIView?
    
    private var _publicBtn: UIView?
    private var _searchBtn: UIView?
    private var _futureBtn: UIView?
    
    private var _historyCommentView: UIView?
    private var _historyTableView: UITableView?
    
    private var historyComments: USComment?
    private var autoScrollView: SMCycleBannerView!
    
    weak var delegate: USHomeViewDelegate?

    //MARK: - ------Life Circle------
    
    init() {
        super.init(frame: .zero)
        self.addSubview(self.scrollView!)
        self.layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ------Methods------
    func layoutPageSubviews() {
        
        self.scrollView!.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    func reloadHistoyCommentView(data: USComment?) {
        self.historyComments = data
        self.historyTableView!.reloadData()
        
        var tableViewHeight = self.historyTableView!.contentSize.height
        tableViewHeight = tableViewHeight > 0 ? tableViewHeight: 66.0
        
        self.historyTableView!.snp.updateConstraints { (make) in
            make.height.equalTo(tableViewHeight)
        }
        self.layoutIfNeeded()
        
        self.historyCommentView!.snp.updateConstraints { (make) in
            make.height.equalTo(tableViewHeight + 70.0)
        }
        
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
    
    //MARK: - ------Delegate View------
    
    //MARK: - ------Delegate Model------
    
    //MARK: - ------Delegate Table------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.historyComments != nil) {
            let commentsArr = self.historyComments!.commentsArr
            if (commentsArr != nil) {
                if commentsArr!.count > 5 {
                    return 5
                } else {
                    return commentsArr!.count
                }
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: historyCommentTableCellIdentifier, for: indexPath) as! USHomeCommentTableViewCell
        
        let commentsArr = self.historyComments!.commentsArr
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
        cell.classNameLab?.text = tempComment.className
        cell.publishTimeLab?.text = "发布于：" + NSDate.init(timeIntervalSince1970: Double(tempComment.time)!).fullDescription()
        cell.diggNumLab!.text = String.init(format: "被赞了%d次", tempComment.digg.intValue)
        cell.classNameLabSizeToFit()
        cell.diggNumLabSizeToFit()

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let commentsArr = self.historyComments!.commentsArr
        let tempComment: USComment! = commentsArr![indexPath.row] as! USComment
        return USHomeCommentTableViewCell.getCellHeight(commentData: tempComment)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let commentsArr = self.historyComments!.commentsArr
        let tempComment: USComment! = commentsArr![indexPath.row] as! USComment
        
        self.delegate?.homeViewHistoryCellDidSelected(tempComment)
    }

    //MARK: - ------Delegate Other------
    
    //MARK: - ------Event Response------
    func publicCommentBtnViewTapGestureAction(sender: UIGestureRecognizer) {
        self.delegate?.homeViewPublishBtnDidClick()
    }
    
    func searchBtnDidClick(sender: UIButton) {
        self.delegate?.homeViewSearchBtnDidClick()
    }
    
    func refreshHistoryCommentBtnDidClick (sender: UIButton) {
        self.delegate?.homeViewRefreshHistoryComment()
    }
    
    func moreBtnDidClick(sender: UIButton) {
        self.delegate?.homeViewMoreHistoryCommentBtnDidClick()
    }
    //MARK: - ------Getters and Setters------
    var scrollView: UIScrollView? {
        get {
            if (_scrollView != nil) {
                return _scrollView
            }
            let scrollV = UIScrollView()
            scrollV.showsVerticalScrollIndicator = false
            scrollV.backgroundColor = UIColor.clear
            scrollV.delegate = self
            scrollV.addSubview(self.containerView!)
            self.containerView!.snp.makeConstraints { (make) in
                make.edges.equalTo(scrollV)
                make.width.equalTo(SCREEN_WIDTH)
            }
            
            _scrollView = scrollV
            return _scrollView
        }
    }

    var containerView: UIView? {
        get {
            if (_containerView != nil) {
                return _containerView
            }
            let view = UIView()
            view.backgroundColor = UIColor.sexLightGray()
            view.addSubview(self.headerView!)
            view.addSubview(self.bodyView!)
            self.headerView!.snp.makeConstraints { (make) in
                make.top.left.right.equalTo(view)
                make.height.equalTo(SCREEN_HEIGHT / 4.0)
            }
            
            self.bodyView!.snp.makeConstraints { (make) in
                make.left.right.equalTo(view)
                make.top.equalTo(self.headerView!.snp.bottom)
            }
            
            view.snp.remakeConstraints { (make) in
                make.bottom.equalTo(self.bodyView!.snp.bottom)
            }
            
            _containerView = view
            return _containerView
        }
    }
    
    var headerView: UIView? {
        get {
            if (_headerView != nil) {
                return _headerView
            }
            let view = UIView()
            view.backgroundColor = UIColor.white
            
            let imgArr: [UIImage] = [UIImage.init(named: "head-background")!, UIImage.init(named: "deliveryDetailHeader")!]

            
            self.autoScrollView = SMCycleBannerView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT / 4))
            self.autoScrollView.initCycleBanner()
            self.autoScrollView.configureImageViews(imgArr, autoScroll: true, didClickEventClosure: nil)
            
            
            view.addSubview(self.autoScrollView)

            _headerView = view
            return _headerView
        }
    }
    
    var bodyView: UIView? {
        get {
            if (_bodyView != nil) {
                return _bodyView
            }
            let view = UIView()
            view.backgroundColor = UIColor.white

            view.addSubview(self.publicBtn!)
            view.addSubview(self.futureBtn!)
            view.addSubview(self.searchBtn!)
            view.addSubview(self.historyCommentView!)
            
            self.searchBtn!.snp.makeConstraints { (make) in
                make.top.equalTo(view).offset(15.0)
                make.left.equalTo(view).offset(20.0)
                make.width.height.equalTo(btnViewHeight)
            }
            
            self.publicBtn!.snp.makeConstraints { (make) in
                make.top.equalTo(view).offset(15.0)
                make.right.equalTo(self.futureBtn!.snp.left).offset(-20.0)
                make.width.height.equalTo(btnViewHeight)
            }
            
            self.futureBtn!.snp.makeConstraints { (make) in
                make.top.equalTo(view).offset(15.0)
                make.right.equalTo(view).offset(-20.0)
                make.width.height.equalTo(btnViewHeight)
            }
            
            self.historyCommentView!.snp.makeConstraints { (make) in
                make.top.equalTo(self.futureBtn!.snp.bottom).offset(20.0)
                make.left.equalTo(view).offset(15.0)
                make.right.equalTo(view).offset(-15.0)
                make.height.equalTo(50 + 70)
            }
            
            view.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.historyCommentView!.snp.bottom).offset(40.0)
            }
            
            _bodyView = view
            return _bodyView
        }
    }

    
    var historyCommentView: UIView? {
        get {
            if (_historyCommentView != nil) {
                return _historyCommentView
            }
            let commentView = UIView()
            commentView.backgroundColor = UIColor.clear
            let topView = UIView()
            topView.backgroundColor = UIColor.sexBlue()
            let label = UILabel()
            //label.text = "\u{e610}"
            
            let attributeStr = NSMutableAttributedString.init(string: "\u{e610} 我的历史评论")
            attributeStr.setAttributes([NSFontAttributeName: UIFont.init(name: "iconfont", size: 16.0) as Any], range: NSRange.init(location: 0, length: 1))
            attributeStr.setAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 14.0) as Any], range: NSRange.init(location: 2, length: 6))
            label.attributedText = attributeStr
            
            label.textColor = UIColor.white
            let updateBtn = UIButton()
            updateBtn.setTitle("\u{e622}", for: .normal)
            updateBtn.setTitleColor(UIColor.white, for: .normal)
            updateBtn.setTitleColor(UIColor.gray, for: .focused)
            updateBtn.titleLabel?.textAlignment = .right
            updateBtn.titleLabel?.font = UIFont.init(name: "iconfont", size: 22.0)
            updateBtn.addTarget(self, action: #selector(self.refreshHistoryCommentBtnDidClick(sender:)), for: .touchUpInside)
            topView.addSubview(updateBtn)
            topView.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.left.equalTo(topView).offset(10.0)
                make.centerY.equalTo(topView)
                make.height.equalTo(15.0)
                make.right.equalTo(updateBtn.snp.left)
            }

            updateBtn.snp.makeConstraints { (make) in
                make.right.equalTo(topView)
                make.centerY.equalTo(topView)
                make.height.equalTo(35.0)
                make.width.equalTo(35)
            }
            
            let bottomView = UIView()
            let moreBtn = UIButton()
            bottomView.addSubview(moreBtn)
            moreBtn.setTitle("查看更多", for: .normal)
            moreBtn.backgroundColor = UIColor.clear
            moreBtn.titleLabel?.textAlignment = .center
            moreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            moreBtn.addTarget(self, action: #selector(self.moreBtnDidClick(sender:)), for: .touchUpInside)
            moreBtn.snp.makeConstraints { (make) in
                make.centerX.equalTo(bottomView)
                make.centerY.equalTo(bottomView)
                make.height.equalTo(bottomView)
                make.width.equalTo(bottomView)
            }
            bottomView.backgroundColor = UIColor.sexBlue()
            commentView.addSubview(topView)
            commentView.addSubview(bottomView)
            topView.snp.makeConstraints { (make) in
                make.top.left.right.equalTo(commentView)
                make.height.equalTo(35)
            }
            bottomView.snp.makeConstraints { (make) in
                make.left.right.equalTo(commentView)
                make.height.equalTo(35)
                make.bottom.equalTo(commentView)
            }
            commentView.layer.cornerRadius = 10.0
            commentView.layer.masksToBounds = true
            commentView.layer.borderWidth = 0.5
            commentView.layer.borderColor = UIColor.sexBlue().cgColor
            
            commentView.insertSubview(self.historyTableView!, belowSubview: bottomView)
            self.historyTableView!.snp.makeConstraints { (make) in
                make.left.right.equalTo(commentView)
                make.top.equalTo(topView.snp.bottom)
                make.height.equalTo(50)
            }
            
            _historyCommentView = commentView
            return _historyCommentView
        }
    }
    
    var historyTableView: UITableView? {
        get {
            if (_historyTableView != nil) {
                return _historyTableView
            }
            let tableView = UITableView()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.register(USHomeCommentTableViewCell.self, forCellReuseIdentifier: historyCommentTableCellIdentifier)
            tableView.separatorStyle = .none
            
            _historyTableView = tableView
            return _historyTableView
        }
    }
    
    var searchBarView: UIView? {
        get {
            if (_searchBarView != nil) {
                return _searchBarView
            }
            let view = UIView()
            _searchBarView = view
            return _searchBarView
        }
        set {
            _searchBarView = newValue
        }
    }
    
    var publicBtn: UIView? {
        get {
            if (_publicBtn != nil) {
                return _publicBtn
            }
            let viewBtn = UIView()
            viewBtn.backgroundColor = UIColor.homeLightYellow()
            viewBtn.layer.cornerRadius = 10.0
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.publicCommentBtnViewTapGestureAction(sender:)))
            viewBtn.isUserInteractionEnabled = true
            viewBtn.addGestureRecognizer(tapGesture)
            
            let imgView = UIImageView()
            imgView.image = UIImage.init(named: "zonghe")
            imgView.contentMode = .scaleAspectFill
            viewBtn.addSubview(imgView)
            imgView.snp.makeConstraints { (make) in
                make.centerY.equalTo(viewBtn).offset(-10.0)
                make.centerX.equalTo(viewBtn)
                make.height.width.equalTo(btnViewHeight / 3.0)
            }
            
            let label = UILabel()
            label.text = "综合交流"
            label.textAlignment = .center
            label.numberOfLines = 2
            label.textColor = UIColor.white
            label.lineBreakMode = .byCharWrapping
            label.font = UIFont.systemFont(ofSize: 14.0)
            viewBtn.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.centerX.equalTo(viewBtn)
                make.bottom.equalTo(viewBtn).offset(-10.0)
                make.height.equalTo(20)
                make.width.equalTo(btnViewHeight - 10.0)
            }
            _publicBtn = viewBtn
            return _publicBtn
        }
    }
    
    var searchBtn: UIView? {
        get {
            if (_searchBtn != nil) {
                return _searchBtn
            }
            let viewBtn = UIView()
            viewBtn.backgroundColor = UIColor.orange
            viewBtn.layer.cornerRadius = 10.0
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.searchBtnDidClick(sender:)))
            viewBtn.isUserInteractionEnabled = true
            viewBtn.addGestureRecognizer(tapGesture)

            let imgView = UIImageView()
            imgView.image = UIImage.init(named: "search")
            imgView.contentMode = .scaleAspectFill
            viewBtn.addSubview(imgView)
            imgView.snp.makeConstraints { (make) in
                make.centerY.equalTo(viewBtn).offset(-10.0)
                make.centerX.equalTo(viewBtn)
                make.height.width.equalTo(btnViewHeight / 4.0)
            }
            
            let label = UILabel()
            label.text = "搜索课程"
            label.textAlignment = .center
            label.numberOfLines = 2
            label.textColor = UIColor.white
            label.lineBreakMode = .byCharWrapping
            label.font = UIFont.systemFont(ofSize: 14.0)
            viewBtn.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.centerX.equalTo(viewBtn)
                make.bottom.equalTo(viewBtn).offset(-10.0)
                make.height.equalTo(20.0)
                make.width.equalTo(btnViewHeight - 10.0)
            }
            
            _searchBtn = viewBtn
            return _searchBtn
        }
    }
    
    var futureBtn: UIView? {
        get {
            if (_futureBtn != nil) {
                return _futureBtn
            }
            let viewBtn = UIView()
            viewBtn.backgroundColor = UIColor.lightGray
            viewBtn.layer.cornerRadius = 10.0

            let imgView = UIImageView()
            imgView.image = UIImage.init(named: "build")
            imgView.contentMode = .scaleAspectFill
            viewBtn.addSubview(imgView)
            imgView.snp.makeConstraints { (make) in
                make.centerY.equalTo(viewBtn).offset(-10.0)
                make.centerX.equalTo(viewBtn)
                make.height.width.equalTo(btnViewHeight / 4.0)
            }
            
            let label = UILabel()
            label.text = "敬请期待..."
            label.textAlignment = .center
            label.numberOfLines = 2
            label.textColor = UIColor.white
            label.lineBreakMode = .byCharWrapping
            label.font = UIFont.systemFont(ofSize: 14.0)
            viewBtn.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.centerX.equalTo(viewBtn)
                make.bottom.equalTo(viewBtn).offset(-10.0)
                make.height.equalTo(20.0)
                make.width.equalTo(btnViewHeight - 10.0)
            }

            
            _futureBtn = viewBtn
            return _futureBtn
        }
    }
    //MARK: - ------Serialize and Deserialize------


}

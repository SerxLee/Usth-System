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
let minOffsetY: CGFloat = SCREEN_HEIGHT / 4.0 - 94.0 + 15.0 + btnViewHeight
let minOfContainerViewHeight: CGFloat = minOffsetY + SCREEN_HEIGHT - 25.0
let emptyViewHeight: CGFloat = 120.0

class USHomeView: UIView , UITableViewDelegate, UITableViewDataSource, CYLTableViewPlaceHolderDelegate {
    private var _fakeNavigationBar: UIView?
    
    private var autoScrollView: SMCycleBannerView!
    
    private var _scrollView: UIScrollView?
    private var _containerView: UIView?
    private var _searchBarView: UIView?
    private var _headerView: UIView?
    private var _bodyView: UIView?
    
    private var _publicBtn: UIView?
    private var publicImageView: UIImageView?
    private var publicBtnImageView: UIImageView?
    private let publicFrame: CGRect = CGRect.init(x: (20.0 + btnViewHeight + 20.0 + btnViewHeight / 3.0), y: (84.0 + 15.0 + btnViewHeight / 3.0 - 10.0), width: btnViewHeight / 3.0, height: btnViewHeight / 3.0)
    private let publicFinalFrame: CGRect = CGRect.init(x: 20.0 + btnViewHeight / 4.0 + 30.0, y: 30.0 + (74 - btnViewHeight / 3.0) / 2.0, width: btnViewHeight / 3.0, height: btnViewHeight / 3.0)
    
    private var _fakeSearchBar: UIView?
    private var _searchBtn: UIView?
    private var searchImageView: UIImageView?
    private var searchBtnImageView: UIImageView?
    private let searchFrame: CGRect = CGRect.init(x: (20.0 + 3.0 * btnViewHeight / 4.0 / 2.0), y: (84.0 + 15.0 + (3.0 * btnViewHeight / 4.0 / 2.0 - 10.0)), width: btnViewHeight / 4.0, height: btnViewHeight / 4.0)
    private let searchFinalFrame: CGRect = CGRect.init(x: 20.0, y: 30.0 + (74 - btnViewHeight / 4.0) / 2.0, width: btnViewHeight / 4.0, height: btnViewHeight / 4.0)

    private var _futureBtn: UIView?
    private var futureImageView: UIImageView?
    private var futureBtnImageView: UIImageView?
    private let futureFrame: CGRect =  CGRect.init(x: (20.0 + (btnViewHeight + 20.0) * 2.0 + 3.0 * btnViewHeight / 4.0 / 2.0), y: (84.0 + 15.0 + (3.0 * btnViewHeight / 4.0 / 2.0 - 10.0)), width: btnViewHeight / 4.0, height: btnViewHeight / 4.0)
    private let futureFinalFrame: CGRect = CGRect.init(x: 20.0 + btnViewHeight / 4.0 + 30.0 + btnViewHeight / 3.0 + 30.0, y: 30.0 + (74 - btnViewHeight / 4.0) / 2.0, width: btnViewHeight / 4.0, height: btnViewHeight / 4.0)
    
    private var _historyCommentView: UIView?
    private var _historyTableView: UITableView?
    private var _emptyView: UIView?
    private var _waitView: UIView?
    private var commentUpdateBtn: UIButton!
    private var waitViewConstraintToTop: Constraint?
    private var waitViewIndicatorView: UIActivityIndicatorView!
    private var waitViewMessageLab: UILabel!
    
    private var _iceMountainImgView: UIImageView?
    
    
    private var historyComments: USComment?

    
    weak var delegate: USHomeViewDelegate?

    //MARK: - ------Life Circle------
    
    init(comment: USComment?) {
        super.init(frame: .zero)
        self.historyComments = comment
        self.addSubview(self.scrollView!)
        self.addSubview(self.fakeNavigationBar!)
        self.addSubview(self.publicImageView!)
        self.addSubview(self.searchImageView!)
        self.addSubview(self.futureImageView!)
        self.layoutPageSubviews()
        self.firstReloadHistoyCommentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ------Methods------
    func layoutPageSubviews() {
        self.fakeNavigationBar?.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(64.0 + 30.0)
        }
        self.scrollView!.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
    }
    
    func reloadHistoyCommentView(data: USComment?) {
        self.historyComments = data
        self.historyTableView!.cyl_reloadData()
        self.layoutIfNeeded()
        
        var tableViewHeight = self.historyTableView!.contentSize.height
        tableViewHeight = tableViewHeight > 0 ? tableViewHeight: emptyViewHeight
        

        self.historyTableView!.snp.updateConstraints { (make) in
            make.height.equalTo(tableViewHeight)
        }
        self.layoutIfNeeded()
        
        let gapForMountain = minOfContainerViewHeight - SCREEN_HEIGHT / 4.0 - 15.0 - btnViewHeight - 20.0 - tableViewHeight - 70.0 - self.iceMountainImgView!.frame.size.height / 23.0 * 7.0 <= 0 ? 0:minOfContainerViewHeight - SCREEN_HEIGHT / 4.0 - 15.0 - btnViewHeight - 20.0 - tableViewHeight - 70.0 - self.iceMountainImgView!.frame.size.height / 23.0 * 7.0
        
        self.historyCommentView!.snp.updateConstraints { (make) in
            make.height.equalTo(tableViewHeight + 70.0)
        }
        self.iceMountainImgView!.snp.updateConstraints { (make) in
            make.top.equalTo(self.historyCommentView!.snp.bottom).offset(gapForMountain)
            
        }
        
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        self.stopReloadHistoryComment { }
    }
    
    func firstReloadHistoyCommentView() {
//        self.historyTableView!.cyl_reloadData()
        var tableViewHeight = self.historyTableView!.contentSize.height
        tableViewHeight = tableViewHeight > 0 ? tableViewHeight: emptyViewHeight
        self.historyTableView!.snp.updateConstraints { (make) in
            make.height.equalTo(tableViewHeight)
        }
        let gapForMountain = minOfContainerViewHeight - SCREEN_HEIGHT / 4.0 - 15.0 - btnViewHeight - 20.0 - tableViewHeight - 70.0 - self.iceMountainImgView!.frame.size.height / 23.0 * 7.0 <= 0 ? 0:minOfContainerViewHeight - SCREEN_HEIGHT / 4.0 - 15.0 - btnViewHeight - 20.0 - tableViewHeight - 70.0 - self.iceMountainImgView!.frame.size.height / 23.0 * 7.0
        self.historyCommentView!.snp.updateConstraints { (make) in
            make.height.equalTo(tableViewHeight + 70.0)
        }
        self.iceMountainImgView!.snp.updateConstraints { (make) in
            make.top.equalTo(self.historyCommentView!.snp.bottom).offset(gapForMountain)
        }
    }
    
    func startReloadHistoryComment(_ Closer: @escaping (()->())) {
        self.commentUpdateBtn.isEnabled = false
        self.waitView?.alpha = 1.0
        self.waitViewMessageLab.text = "努力获取数据ing"
        self.waitViewIndicatorView.startAnimating()
        UIView.animate(withDuration: 0.3, animations: {
            self.waitViewConstraintToTop?.update(offset: 35.0)
            self.layoutIfNeeded()
        }) { (finish) in
            Closer()
        }
    }
    
    func firstStartReloadHistoryComment(_ Closer: @escaping (()->())) {
        self.commentUpdateBtn.isEnabled = false
        self.waitView?.alpha = 1.0
        self.waitViewMessageLab.text = "努力获取数据ing"
        self.waitViewIndicatorView.startAnimating()
        self.waitViewConstraintToTop?.update(offset: 35.0)
        self.layoutIfNeeded()
        Closer()
    }

    
    func stopReloadHistoryComment(_ Closer: @escaping (()->())) {
        self.commentUpdateBtn.isEnabled = true
        self.waitViewIndicatorView.stopAnimating()
        self.waitViewMessageLab.text = "刷新数据成功"
        UIView.animate(withDuration: 0.3, delay: 1.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.waitViewConstraintToTop?.update(offset: 0.0)
            self.waitView?.alpha = 0.0
            self.layoutIfNeeded()
        }) { (finish) in
            Closer()
        }
    }
    
    func stopReloadHistoryCommentWithError(_ error: USError) {
        self.commentUpdateBtn.isEnabled = true
        self.waitViewIndicatorView.stopAnimating()
        self.waitViewMessageLab.text = error.userInfo[NSLocalizedDescriptionKey] as? String
        UIView.animate(withDuration: 0.3, delay: 1.0, options: UIViewAnimationOptions.curveEaseOut, animations: { 
            self.waitViewConstraintToTop?.update(offset: 0.0)
            self.waitView?.alpha = 0.0
            self.layoutIfNeeded()
        }) { (finish) in
            
        }
    }
    
    func changeBtnImageState(is showFake: CGFloat) {
        self.publicImageView?.alpha = showFake
        self.searchImageView?.alpha = showFake
        self.futureImageView?.alpha = showFake
        self.publicBtnImageView?.alpha = 1.0 - showFake
        self.searchBtnImageView?.alpha = 1.0 - showFake
        self.futureBtnImageView?.alpha = 1.0 - showFake
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
        let cell = tableView.dequeueReusableCell(withIdentifier: historyCommentTableCellIdentifier) as! USHomeCommentTableViewCell
        
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
        cell.publishTimeLab?.text = "发表于：" + NSDate.init(timeIntervalSince1970: Double(tempComment.time)!).fullDescription()
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == self.scrollView) {
            let offset = scrollView.contentOffset.y
            if offset <= 0 {
                scrollView.contentOffset.y = 0.0
                self.fakeNavigationBar?.alpha = 0.0
                self.changeBtnImageState(is: 0.0)
            }
            else {
                if (offset <= SCREEN_HEIGHT / 4 - 84.0) {
                    let value = offset / (SCREEN_HEIGHT / 4 - 84.0)
                    self.fakeNavigationBar?.alpha = value
                    self.changeBtnImageState(is: 0)
                }
                else {
                    self.fakeNavigationBar?.alpha = 1.0
                    //
                    self.changeBtnImageState(is: 1.0)
                    if (offset - (SCREEN_HEIGHT / 4 - 84.0) <= btnViewHeight) {
                        let value = (offset - (SCREEN_HEIGHT / 4 - 84.0)) / btnViewHeight
                        self.publicImageView?.frame = CGRect.init(x: self.publicFrame.origin.x - (self.publicFrame.origin.x - self.publicFinalFrame.origin.x) * pow(value, 2), y: self.publicFrame.origin.y - (self.publicFrame.origin.y - self.publicFinalFrame.origin.y) * value, width: self.publicFrame.size.width, height: self.publicFrame.size.height)
                        self.searchImageView?.frame = CGRect.init(x: self.searchFrame.origin.x - (self.searchFrame.origin.x - self.searchFinalFrame.origin.x) * pow(value, 2), y: self.searchFrame.origin.y - (self.searchFrame.origin.y - self.searchFinalFrame.origin.y) * value, width: self.searchFrame.size.width, height: self.searchFrame.size.height)
                        self.futureImageView?.frame = CGRect.init(x: self.futureFrame.origin.x - (self.futureFrame.origin.x - self.futureFinalFrame.origin.x) * pow(value, 2), y: self.futureFrame.origin.y - (self.futureFrame.origin.y - self.futureFinalFrame.origin.y) * value, width: self.futureFrame.size.width, height: self.futureFrame.size.height)
                    }
                    else {
                        self.publicImageView?.frame = self.publicFinalFrame
                        self.searchImageView?.frame = self.searchFinalFrame
                        self.futureImageView?.frame = self.futureFinalFrame
                    }
                    
                }
                
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            if (scrollView == self.scrollView) {
                let offset = scrollView.contentOffset
                if offset.y > 0 {
                    if offset.y < SCREEN_HEIGHT / 4 - 84.0 {
                        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
                    }
                    else {
                        if offset.y - (SCREEN_HEIGHT / 4 - 84.0 + 5.0) <= btnViewHeight {
                            scrollView.setContentOffset(CGPoint.init(x: 0, y: minOffsetY), animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView == self.scrollView) {
            let offset = scrollView.contentOffset
            if offset.y > 0 {

                if offset.y < SCREEN_HEIGHT / 4 - 84.0 {
                    scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
                }
                else {
                    if offset.y - (SCREEN_HEIGHT / 4 - 84.0 + 5.0) <= btnViewHeight {
                        scrollView.setContentOffset(CGPoint.init(x: 0, y: minOffsetY), animated: true)
                    }
                }
            }
        }
    }
    
    func makePlaceHolderView() -> UIView! {
        return self.emptyView!
    }
    //MARK: - ------Event Response------
    func publicCommentBtnViewTapGestureAction(sender: UIGestureRecognizer) {
        self.delegate?.homeViewPublishBtnDidClick()
    }
    
    func searchBtnDidClick(sender: UIButton) {
        self.delegate?.homeViewSearchBtnDidClick()
    }
    
    func refreshHistoryCommentBtnDidClick (sender: UIButton) {
        self.startReloadHistoryComment {
            self.delegate?.homeViewRefreshHistoryComment()
        }
    }
    
    func moreBtnDidClick(sender: UIButton) {
        self.delegate?.homeViewMoreHistoryCommentBtnDidClick()
    }
    //MARK: - ------Getters and Setters------
    var fakeNavigationBar: UIView? {
        get {
            if (_fakeNavigationBar != nil) {
                return _fakeNavigationBar
            }
            let view = UIView()
            view.backgroundColor = UIColor.sexBlue()
            view.alpha = 0.0
            
            self.publicImageView = UIImageView.init(frame: self.publicFrame)
            self.publicImageView!.image = UIImage.init(named: "zonghe")
            self.publicImageView!.contentMode = .scaleAspectFill
            self.publicImageView!.alpha = 0.0
            self.publicImageView!.isUserInteractionEnabled = true
            let publicTap = UITapGestureRecognizer.init(target: self, action: #selector(self.publicCommentBtnViewTapGestureAction(sender:)))
            self.publicImageView!.addGestureRecognizer(publicTap)
            
            self.searchImageView = UIImageView.init(frame: self.searchFrame)
            self.searchImageView!.image = UIImage.init(named: "search")
            self.searchImageView!.contentMode = .scaleAspectFill
            self.searchImageView!.alpha = 0.0
            self.searchImageView!.isUserInteractionEnabled = true
            let searchTap = UITapGestureRecognizer.init(target: self, action: #selector(self.searchBtnDidClick(sender:)))
            self.searchImageView!.addGestureRecognizer(searchTap)
            
            self.futureImageView = UIImageView.init(frame: self.futureFrame)
            self.futureImageView!.image = UIImage.init(named: "build")
            self.futureImageView!.contentMode = .scaleAspectFill
            self.futureImageView!.alpha = 0.0
//            view.addSubview(self.fakeSearchBar!)
            
            _fakeNavigationBar = view
            return _fakeNavigationBar
        }
    }
    
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
            view.addSubview(self.iceMountainImgView!)
            
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
                make.height.equalTo(emptyViewHeight + 70.0)
            }
            
            
            self.iceMountainImgView!.snp.makeConstraints { (make) in
                make.width.equalTo(self.iceMountainImgView!.frame.size.width)
                make.height.equalTo(self.iceMountainImgView!.frame.size.height)
                make.left.equalTo(view)
                make.top.equalTo(self.historyCommentView!.snp.bottom).offset(minOfContainerViewHeight - SCREEN_HEIGHT / 4.0 - 15.0 - btnViewHeight - 20.0 - emptyViewHeight - 70.0 - self.iceMountainImgView!.frame.size.height / 23.0 * 7.0)
            }
            
            /*
            view.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.historyCommentView!.snp.bottom).offset(40.0)
            }
             */
            view.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.iceMountainImgView!.snp.bottom).offset(-(self.iceMountainImgView!.frame.size.height / 23.0 * 16.0))
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
            
            let attributeStr = NSMutableAttributedString.init(string: "\u{e63c} 我的历史评论")
            attributeStr.setAttributes([NSFontAttributeName: UIFont.init(name: "iconfont", size: 16.0) as Any], range: NSRange.init(location: 0, length: 1))
            attributeStr.setAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 14.0) as Any], range: NSRange.init(location: 2, length: 6))
            label.attributedText = attributeStr
            
            label.textColor = UIColor.white
            let updateBtn = UIButton()
            updateBtn.setTitle("\u{e754}", for: .normal)
            updateBtn.setTitleColor(UIColor.white, for: .normal)
            updateBtn.setTitleColor(UIColor.gray, for: .focused)
            updateBtn.titleLabel?.textAlignment = .right
            updateBtn.titleLabel?.font = UIFont.init(name: "iconfont", size: 22.0)
            updateBtn.addTarget(self, action: #selector(self.refreshHistoryCommentBtnDidClick(sender:)), for: .touchUpInside)
            self.commentUpdateBtn = updateBtn
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
                make.height.equalTo(23.0)
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
            commentView.addSubview(self.historyTableView!)
            commentView.addSubview(self.waitView!)
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
            
            self.waitView!.snp.makeConstraints { (make) in
                make.left.right.equalTo(commentView)
                make.height.equalTo(35.0)
                self.waitViewConstraintToTop = make.top.equalTo(commentView).constraint
            }
            
//            commentView.insertSubview(self.historyTableView!, belowSubview: bottomView)
            self.historyTableView!.snp.makeConstraints { (make) in
                make.left.right.equalTo(commentView)
                make.top.equalTo(topView.snp.bottom)
                make.height.equalTo(emptyViewHeight)
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
    
    var waitView: UIView? {
        get {
            if _waitView != nil {
                return _waitView
            }
            let view = UIView()
            view.backgroundColor = UIColor.homeLightYellow()
            let activityView = UIActivityIndicatorView()
            activityView.hidesWhenStopped = true
            self.waitViewIndicatorView = activityView
            let messageLab = UILabel()
            messageLab.text = "努力获取数据ing"
            messageLab.textAlignment = .center
            messageLab.font = UIFont.systemFont(ofSize: 13.0)
            messageLab.textColor = UIColor.white
            self.waitViewMessageLab = messageLab
            view.addSubview(activityView)
            view.addSubview(messageLab)
            messageLab.snp.makeConstraints { (make) in
                make.width.equalTo(105.0)
                make.height.equalTo(20.0)
                make.centerX.equalTo(view)
                make.centerY.equalTo(view)
            }
            activityView.snp.makeConstraints { (make) in
                make.left.equalTo(messageLab.snp.right)
                make.width.height.equalTo(25.0)
                make.centerY.equalTo(view)
            }
            
            _waitView = view
            return _waitView
        }
    }
    
    var emptyView: UIView? {
        get {
            if _emptyView != nil {
                return _emptyView
            }
            let view = UIView()
            let imgView = UIImageView()
            imgView.image = UIImage.init(named: "NotFound")
            imgView.contentMode = .scaleAspectFit
            let messageLab = UILabel()
            messageLab.text = "没有吐槽过，不开森"
            messageLab.textAlignment = .center
            messageLab.font = UIFont.systemFont(ofSize: 13.0)
            messageLab.textColor = UIColor.lightGray
            view.addSubview(messageLab)
            view.addSubview(imgView)
            imgView.snp.makeConstraints { (make) in
                make.centerX.equalTo(view)
                make.centerY.equalTo(view).offset(-10.0)
                make.height.equalTo(85.0)
                make.width.equalTo(85.0)
            }
            messageLab.snp.makeConstraints { (make) in
                make.top.equalTo(imgView.snp.bottom).offset(-15.0)
                make.centerX.equalTo(imgView)
                make.left.equalTo(view)
                make.right.equalTo(view)
            }
            
            _emptyView = view
            return _emptyView
        }
    }
    
     
    var iceMountainImgView: UIImageView? {
        get {
            if (_iceMountainImgView != nil) {
                return _iceMountainImgView
            }
            let imgView = UIImageView()
            let img = UIImage.init(named: "bingshan1")
            imgView.image = img
            let imgSize = img!.size
            imgView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH * (imgSize.height / imgSize.width))
            
            
            _iceMountainImgView = imgView
            return _iceMountainImgView
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
            self.publicBtnImageView = imgView
            
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
    
    var fakeSearchBar: UIView? {
        get {
            if _fakeSearchBar != nil {
                return _fakeSearchBar
            }
            let view = UIView()
            view.backgroundColor = UIColor.white
            view.frame = CGRect.init(x: 20.0 + btnViewHeight / 3.0 + 20.0, y: 20 + 22 + 1, width: 180, height: 30.0)
            view.layer.cornerRadius = 4.0
            view.layer.borderColor = UIColor.white.cgColor
            view.layer.borderWidth = 0.5
            
            _fakeSearchBar = view
            return _fakeSearchBar
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
            self.searchBtnImageView = imgView
            
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
            self.futureBtnImageView = imgView
            
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

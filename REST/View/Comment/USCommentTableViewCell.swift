//
//  USCommentTableViewCell.swift
//  Usth System
//
//  Created by Serx on 2017/5/29.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol USCommentTableViewCellDelegate: NSObjectProtocol {
    @objc optional func commentTableViewCell(commentCell: USCommentTableViewCell, didClickReplyBtn: UIButton)
    @objc optional func commentTableViewCell(commentCell: USCommentTableViewCell, didClickDiggBtn: UIButton)
    @objc optional func commentTableViewCellTapHeader(commentCell: USCommentTableViewCell)
}

let commentCellMinHeight: CGFloat = 64.0
let replyCommentShorterThanCommentWidth: CGFloat = 22.0
let commentTextViewShorterThanCellWidth: CGFloat = 66.0


class USCommentTableViewCell: UITableViewCell {
    
    weak var delegate: USCommentTableViewCellDelegate?
    
    private var _headerImgView: UIImageView?
    private var _publishTimeLab: UILabel?
    private var _replyBtn: UIButton?
    private var _diggBtn: UIButton?
    private var _diggNumLab: UILabel?
    private var _commentTextView: UITextView?
    private var _replyCommentTextView: UITextView?
    
    var commentWidth: Float? = 0.0
    var replyCommentWidth: Float? = 0.0
    
    //MARK: - ------Life Circle------
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(self.headerImgView!)
        self.contentView.addSubview(self.commentTextView!)
        self.contentView.addSubview(self.replyCommentTextView!)
        self.contentView.addSubview(self.publishTimeLab!)
        self.contentView.addSubview(self.diggBtn!)
        self.contentView.addSubview(self.diggNumLab!)
        self.contentView.addSubview(self.replyBtn!)
        self.layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    //MARK: - ------Methods------
    func layoutPageSubviews() {
        let line = UIView()
        line.backgroundColor = UIColor.lineGray()
        self.contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.right.bottom.equalTo(self.contentView)
        }
        
        self.headerImgView!.snp.makeConstraints { (make) in
            make.height.width.equalTo(50.0)
            make.top.left.equalTo(self.contentView).offset(10.0)
        }
        self.commentTextView!.snp.makeConstraints { (make) in
            make.left.equalTo(self.headerImgView!.snp.right).offset(10.0)
            make.top.equalTo(self.contentView).offset(10.0)
            make.right.equalTo(self.contentView).offset(-15.0)
            make.height.equalTo(10.0)
        }
        self.replyCommentTextView!.snp.makeConstraints { (make) in
            make.top.equalTo(self.commentTextView!.snp.bottom)
            make.right.equalTo(self.contentView).offset(-15.0)
            make.left.equalTo(self.commentTextView!).offset(replyCommentShorterThanCommentWidth)
            make.height.equalTo(10.0)
        }
        self.publishTimeLab!.snp.makeConstraints { (make) in
            make.left.equalTo(self.commentTextView!)
            make.bottom.equalTo(self.contentView).offset(-6.0)
            make.right.equalTo(self.diggBtn!.snp.left)
            make.height.equalTo(22.0)
        }
        self.replyBtn!.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-10.0)
            make.width.equalTo(30.0)
            make.height.equalTo(24.0)
            make.centerY.equalTo(self.publishTimeLab!.snp.centerY)
        }
        self.diggNumLab!.snp.makeConstraints { (make) in
            make.width.equalTo(30.0)
            make.height.equalTo(17.0)
            make.right.equalTo(self.replyBtn!.snp.left)
            make.centerY.equalTo(self.publishTimeLab!.snp.centerY)
        }
        self.diggBtn!.snp.makeConstraints { (make) in
            make.width.height.equalTo(15.0)
            make.right.equalTo(self.diggNumLab!.snp.left).offset(-3.0)
            make.centerY.equalTo(self.publishTimeLab!.snp.centerY)
        }
    }
    
    func setCommentTextView(authorName: String, commentStr: String) {
        self.layoutIfNeeded()
        let width = self.commentTextView?.bounds.size.width
        let rect = self.commentTextView?.commentTextViewAttributedText(withCommentStr: commentStr, andAuthorName: authorName, withWidth: width!)
        self.commentTextView!.snp.updateConstraints { (make) in
            make.height.equalTo(ceilf(Float(rect!.height + 10.0)))
        }
    }
    
    func setReplyCommentTextView(authorName: String, commentStr: String) {
        self.layoutIfNeeded()
        let width = self.replyCommentTextView?.bounds.size.width
        let rect = self.replyCommentTextView?.commentTextViewAttributedText(withCommentStr: commentStr, andAuthorName: authorName, withWidth: width!)
        self.replyCommentTextView!.snp.updateConstraints { (make) in
            make.height.equalTo(ceilf(Float(rect!.height + 10.0)))
        }
    }
    
    static func getCellHeight(commentData: USComment?) -> CGFloat {
        var cellHeight: CGFloat = 10.0 + 10.0 + 25.0 + 10.0
        let commentRect = UITextView.commentTextViewAttributedText(withCommentStr: commentData!.content, andAuthorName: commentData!.authorName, withWidth: SCREEN_WIDTH - commentTextViewShorterThanCellWidth)
        cellHeight = cellHeight + CGFloat(ceilf(Float(commentRect.height)))
        if (!commentData!.refedContent.isEmpty) {
            let commentRect = UITextView.commentTextViewAttributedText(withCommentStr: commentData!.refedContent, andAuthorName: commentData?.refedAuthor, withWidth: SCREEN_WIDTH - commentTextViewShorterThanCellWidth - replyCommentShorterThanCommentWidth)
            cellHeight = cellHeight + CGFloat(ceilf(Float(commentRect.height))) + 10.0
        }
        return cellHeight > commentCellMinHeight ? cellHeight : commentCellMinHeight
    }
    
    func diggNumLabSizeToFit() {
        self.diggNumLab!.sizeToFit()
        self.diggNumLab!.snp.updateConstraints { (make) in
            make.width.equalTo(self.diggNumLab!.bounds.size.width)
        }
    }
    //MARK: - ------Delegate View------
    
    //MARK: - ------Delegate Model------
    
    //MARK: - ------Delegate Table------
    
    //MARK: - ------Delegate Other------
    
    //MARK: - ------Event Response------
    func replyBtnDidClick(button: UIButton) {
        self.delegate?.commentTableViewCell!(commentCell: self, didClickReplyBtn: button)
    }
    
    func diggBtnDidClick(button: UIButton) {
        self.delegate?.commentTableViewCell!(commentCell: self, didClickDiggBtn: button)
    }
    
    func headerImgDidTap(gesture: UITapGestureRecognizer) {
        self.delegate?.commentTableViewCellTapHeader!(commentCell: self)
    }
    //MARK: - ------Getters and Setters------
    var headerImgView: UIImageView? {
        get {
            if (_headerImgView != nil) {
                return _headerImgView
            }
            let imgView = UIImageView()
            imgView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.headerImgDidTap(gesture:)))
            imgView.addGestureRecognizer(tapGesture)
            _headerImgView = imgView
            return _headerImgView
        }
    }
    var publishTimeLab: UILabel? {
        get {
            if (_publishTimeLab != nil) {
                return _publishTimeLab
            }
            let label = UILabel()
            label.backgroundColor = UIColor.clear
            label.textColor = UIColor.myinforGray()
            label.font = UIFont.systemFont(ofSize: 12.0)
            _publishTimeLab = label
            return _publishTimeLab
        }
    }
    var replyBtn: UIButton? {
        get {
            if (_replyBtn != nil) {
                return _replyBtn
            }
            let button = UIButton()
            button.addTarget(self, action: #selector(self.replyBtnDidClick(button:)), for: .touchUpInside)
            button.setImage(UIImage.init(named: "replyIcon"), for: .normal)
            _replyBtn = button
            return _replyBtn
        }
    }
    var diggBtn: UIButton? {
        get {
            if (_diggBtn != nil) {
                return _diggBtn
            }
            let button = UIButton()
            button.addTarget(self, action: #selector(self.diggBtnDidClick(button:)), for: .touchUpInside)
            button.setImage(UIImage.init(named: "blackHeart"), for: .normal)
            _diggBtn = button
            return _diggBtn
        }
    }
    var diggNumLab: UILabel? {
        get {
            if (_diggNumLab != nil) {
                return _diggNumLab
            }
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12.0)
            label.textAlignment = .left
            _diggNumLab = label
            return _diggNumLab
        }
    }
    var commentTextView: UITextView? {
        get {
            if (_commentTextView != nil) {
                return _commentTextView
            }
            let textView = UITextView()
            //textView.backgroundColor = UIColor.orange
            textView.isScrollEnabled = false
            textView.showsVerticalScrollIndicator = false
            textView.showsHorizontalScrollIndicator = false
            textView.isEditable = false
            textView.isSelectable = false
            textView.isUserInteractionEnabled = false
            
            _commentTextView = textView
            return _commentTextView
        }
    }
    var replyCommentTextView: UITextView? {
        get {
            if (_replyCommentTextView != nil) {
                return _replyCommentTextView
            }
            let textView = UITextView()
            textView.backgroundColor = UIColor.lightGray
            textView.isScrollEnabled = false
            textView.showsVerticalScrollIndicator = false
            textView.showsHorizontalScrollIndicator = false
            textView.isEditable = false
            textView.isSelectable = false
            textView.isUserInteractionEnabled = false
            textView.layer.cornerRadius = 2.0
            
            _replyCommentTextView = textView
            return _replyCommentTextView
        }
    }
    //MARK: - ------Serialize and Deserialize------

}

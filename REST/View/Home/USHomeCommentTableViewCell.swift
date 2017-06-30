//
//  USHomeCommentTableViewCell.swift
//  Usth System
//
//  Created by Serx on 2017/6/1.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit

class USHomeCommentTableViewCell: UITableViewCell {
    
    private var _headerImgView: UIImageView?
    private var _publishTimeLab: UILabel?
    private var _diggNumLab: UILabel?
    private var _commentTextView: UITextView?
    private var _replyCommentTextView: UITextView?
    private var _classNameLab: UILabel?
    private var _authorNameLab: UILabel?

    
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
        self.contentView.addSubview(self.diggNumLab!)
        self.contentView.addSubview(self.classNameLab!)
        self.contentView.addSubview(self.authorNameLab!)
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
        let line = UIView.init()
        line.backgroundColor = UIColor.lineGray()
        self.contentView.addSubview(line)
        
        line.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.contentView)
            make.height.equalTo(0.5)
            make.bottom.equalTo(self.contentView)
        }
        
        self.headerImgView!.snp.makeConstraints { (make) in
            make.height.width.equalTo(30.0)
            make.left.equalTo(self.contentView).offset(10.0)
            make.top.equalTo(self.contentView).offset(5.0)
        }
        
        self.authorNameLab!.snp.makeConstraints { (make) in
            make.left.equalTo(self.headerImgView!.snp.right).offset(10.0)
            make.height.equalTo(16.0)
            make.width.equalTo(60.0)
            make.bottom.equalTo(self.headerImgView!.snp.bottom)
        }
        
        self.commentTextView!.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10.0)
            make.top.equalTo(self.headerImgView!.snp.bottom).offset(5.0)
            make.right.equalTo(self.contentView).offset(-10.0)
            make.height.equalTo(10.0)
        }
        self.replyCommentTextView!.snp.makeConstraints { (make) in
            make.top.equalTo(self.commentTextView!.snp.bottom)
            make.right.equalTo(self.contentView).offset(-10.0)
            make.left.equalTo(self.commentTextView!).offset(replyCommentShorterThanCommentWidth)
            make.height.equalTo(10.0)
        }
        self.publishTimeLab!.snp.makeConstraints { (make) in
            make.left.equalTo(self.headerImgView!)
            make.bottom.equalTo(self.headerImgView!.snp.bottom)
            make.right.equalTo(self.contentView).offset(-10.0)
            make.height.equalTo(14.0)
        }

        self.classNameLab!.snp.makeConstraints { (make) in
            make.left.equalTo(self.headerImgView!)
            //make.top.equalTo(self.commentTextView!.snp.bottom).offset(10.0)
            make.bottom.equalTo(self.contentView).offset(-6.0)
            make.width.equalTo(45.0)
            make.height.equalTo(18.0)
        }
        
        self.diggNumLab!.snp.makeConstraints { (make) in
            make.width.equalTo(30.0)
            make.height.equalTo(12.0)
            make.right.equalTo(self.commentTextView!)
            make.centerY.equalTo(self.classNameLab!.snp.centerY)
        }

    }
    
    func setCommentTextView(authorName: String, commentStr: String) {
        self.layoutIfNeeded()
        let width = self.commentTextView?.bounds.size.width
        let rect = self.commentTextView?.commentTextViewAttributedText(withCommentStr: commentStr, andAuthorName: authorName, withWidth: width!)
        let height = ceilf(Float(rect!.height))
        self.commentTextView!.snp.updateConstraints { (make) in
            make.height.equalTo(height + 16.0)
        }
        /*
        self.classNameLab!.snp.updateConstraints { (make) in
            make.top.equalTo(self.commentTextView!.snp.bottom).offset(5.0)
        }
         */
    }
    
    func setReplyCommentTextView(authorName: String, commentStr: String) {
        self.layoutIfNeeded()
        let width = self.replyCommentTextView?.bounds.size.width
        let rect = self.replyCommentTextView?.commentTextViewAttributedText(withCommentStr: commentStr, andAuthorName: authorName, withWidth: width!)
        let height = ceilf(Float(rect!.height))
        self.replyCommentTextView!.snp.updateConstraints { (make) in
            make.height.equalTo(height + 10.0)
        }
        /*
        self.classNameLab!.snp.updateConstraints { (make) in
            make.top.equalTo(self.commentTextView!.snp.bottom).offset(Float(rect!.height + 8.0 + 10.0))
        }
         */
    }
    
    static func getCellHeight(commentData: USComment?) -> CGFloat {
        var cellHeight: CGFloat = 10.0 + 10.0 + 25.0 + 10.0 + 5.0
        let commentRect = UITextView.commentTextViewAttributedText(withCommentStr: commentData!.content, andAuthorName: commentData!.authorName, withWidth: SCREEN_WIDTH - commentTextViewShorterThanCellWidth)
        cellHeight = cellHeight + CGFloat(ceilf(Float(commentRect.height)))
        if (!commentData!.refedContent.isEmpty) {
            let commentRect = UITextView.commentTextViewAttributedText(withCommentStr: commentData!.refedContent, andAuthorName: commentData?.refedAuthor, withWidth: SCREEN_WIDTH - commentTextViewShorterThanCellWidth - replyCommentShorterThanCommentWidth)
            cellHeight = cellHeight + CGFloat(ceilf(Float(commentRect.height))) + 10.0
        }
        return cellHeight > commentCellMinHeight ? cellHeight : commentCellMinHeight
    }
    
    func classNameLabSizeToFit() {
        self.classNameLab!.sizeToFit()
        self.classNameLab!.snp.updateConstraints { (make) in
            make.width.equalTo(self.classNameLab!.bounds.size.width + 20.0)
        }
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

    //MARK: - ------Getters and Setters------
    
    
    var headerImgView: UIImageView? {
        get {
            if (_headerImgView != nil) {
                return _headerImgView
            }
            let imgView = UIImageView()
            _headerImgView = imgView
            return _headerImgView
        }
    }
    
    var authorNameLab: UILabel? {
        get {
            if (_authorNameLab != nil) {
                return _authorNameLab
            }
            let label = UILabel()
            label.backgroundColor = UIColor.clear
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 16.0)
            _authorNameLab = label
            return _authorNameLab
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
            label.textAlignment = .right
            label.font = UIFont.systemFont(ofSize: 12.0)
            _publishTimeLab = label
            return _publishTimeLab
        }
    }

    var diggNumLab: UILabel? {
        get {
            if (_diggNumLab != nil) {
                return _diggNumLab
            }
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12.0)
            label.textAlignment = .right
            _diggNumLab = label
            return _diggNumLab
        }
    }
    
    var classNameLab: UILabel? {
        get {
            if (_classNameLab != nil) {
                return _classNameLab
            }
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 13.0)
            label.textAlignment = .center
            label.textColor = UIColor.noodleBlueDark()
            label.layer.cornerRadius = 10.0
            label.layer.borderWidth = 0.5
            label.layer.borderColor = UIColor.lineGray().cgColor
            
            _classNameLab = label
            return _classNameLab
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
            textView.backgroundColor = UIColor.lineGray()
            textView.isScrollEnabled = false
            textView.showsVerticalScrollIndicator = false
            textView.showsHorizontalScrollIndicator = false
            textView.layer.cornerRadius = 2.0
            textView.isEditable = false
            textView.isSelectable = false
            textView.isUserInteractionEnabled = false
            
            _replyCommentTextView = textView
            return _replyCommentTextView
        }
    }
    //MARK: - ------Serialize and Deserialize------
    
}

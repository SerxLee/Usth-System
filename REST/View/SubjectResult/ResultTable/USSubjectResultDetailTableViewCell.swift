//
//  USSubjectResultDetailTableViewCell.swift
//  Usth System
//
//  Created by Serx on 2017/6/7.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit

class USSubjectResultDetailTableViewCell: UITableViewCell {

    private var _classNameLab: UILabel?
    private var _scoreLab: UILabel?
    private var _scoreTitleLab: UILabel?
    private var _creditLab: UILabel?
    private var _typeLab: UILabel?
    private var _classIdLab: UILabel?
    
    private var _subjectResultIconLab: UILabel?
    
    //MARK: - ------Life Circle------
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(self.classNameLab!)
        self.contentView.addSubview(self.scoreTitleLab!)
        self.contentView.addSubview(self.scoreLab!)
        self.contentView.addSubview(self.subjectResultIconLab!)
        self.contentView.addSubview(self.creditLab!)
        self.contentView.addSubview(self.classIdLab!)
        self.contentView.addSubview(self.typeLab!)
        self.layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    //MARK: - ------Methods------
    func layoutPageSubviews() {
        let line = self.lineView()
        self.contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.equalTo(self.contentView).offset(20.0)
            make.right.equalTo(self.contentView).offset(-20.0)
            make.top.equalTo(self.classNameLab!.snp.bottom).offset(5.0)
        }
        self.classNameLab!.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10.0)
            make.left.equalTo(self.contentView).offset(15.0)
            make.right.equalTo(self.contentView)
            make.height.equalTo(21.0)
        }
        
        self.scoreTitleLab!.snp.makeConstraints { (make) in
            make.top.equalTo(line).offset(10.0)
            make.width.equalTo(80.0)
            make.left.equalTo(self.contentView).offset(40.0)
            make.height.equalTo(15.0)
        }
        
        self.scoreLab!.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.scoreTitleLab!).offset(8.0)
            make.left.equalTo(self.scoreTitleLab!.snp.right)
            make.width.equalTo(40.0)
            make.height.equalTo(25.0)
        }
        
        self.subjectResultIconLab!.snp.makeConstraints { (make) in
            make.top.equalTo(self.scoreLab!.snp.bottom).offset(-12.0)
            make.width.equalTo(100.0)
            make.height.equalTo(20.0)
            make.left.equalTo(self.scoreLab!).offset(-12.0)
        }
        
        self.creditLab!.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset((SCREEN_WIDTH - 40.0) / 2.0 + 40.0)
            make.top.equalTo(line).offset(10.0)
            make.height.equalTo(15.0)
            make.right.equalTo(self.contentView)
        }
        
        self.classIdLab!.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(40.0)
            make.top.equalTo(self.scoreTitleLab!.snp.bottom).offset(13.0)
            make.height.equalTo(15.0)
            make.width.equalTo((SCREEN_WIDTH - 40.0) / 2.0)
        }

        self.typeLab!.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset((SCREEN_WIDTH - 40.0) / 2.0 + 40.0)
            make.top.equalTo(self.classIdLab!)
            make.height.equalTo(15.0)
            make.right.equalTo(self.contentView)
        }
        
        let bottomLine = self.lineView()
        self.contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
    }
    
    //MARK: - ------Delegate View------
    
    //MARK: - ------Delegate Model------
    
    //MARK: - ------Delegate Table------
    
    //MARK: - ------Delegate Other------
    
    //MARK: - ------Event Response------
    
    //MARK: - ------Getters and Setters------
    func lineView() -> UIView {
        let tempView = UIView()
        tempView.backgroundColor = UIColor.lineGray()
        return tempView
    }
    
    var classNameLab: UILabel? {
        get {
            if (_classNameLab != nil) {
                return _classNameLab
            }
            let tempLab = UILabel.init()
            tempLab.font = UIFont.systemFont(ofSize: 16.0)
            _classNameLab = tempLab
            return _classNameLab
        }
    }
    var scoreLab: UILabel? {
        get {
            if (_scoreLab != nil) {
                return _scoreLab
            }
            let tempLab = UILabel.init()
            tempLab.textColor = UIColor.sexRed()
            tempLab.font = UIFont.init(name: "Zapfino", size: 14.0)
            _scoreLab = tempLab
            return _scoreLab
        }
    }
    
    var creditLab: UILabel? {
        get {
            if (_creditLab != nil) {
                return _creditLab
            }
            let tempLab = UILabel.init()
            tempLab.font = UIFont.systemFont(ofSize: 14.0)
            _creditLab = tempLab
            return _creditLab
        }
    }
    var typeLab: UILabel? {
        get {
            if (_typeLab != nil) {
                return _typeLab
            }
            let tempLab = UILabel.init()
            tempLab.textColor = UIColor.myinforGray()
            tempLab.font = UIFont.systemFont(ofSize: 14.0)
            _typeLab = tempLab
            return _typeLab
        }
    }
    var classIdLab: UILabel? {
        get {
            if (_classIdLab != nil) {
                return _classIdLab
            }
            let tempLab = UILabel.init()
            tempLab.textColor = UIColor.myinforGray()
            tempLab.font = UIFont.systemFont(ofSize: 14.0)
            _classIdLab = tempLab
            return _classIdLab
        }
    }
    
    var subjectResultIconLab: UILabel? {
        get {
            if (_subjectResultIconLab != nil) {
                return _subjectResultIconLab
            }
            let tempLab = UILabel.init()
            tempLab.backgroundColor = UIColor.clear
            tempLab.text = "\u{e602}"
            tempLab.font = UIFont.init(name: "iconfont", size: 13.0)
            tempLab.textColor = UIColor.sexRed()
            _subjectResultIconLab = tempLab
            return _subjectResultIconLab
        }
    }
    
    private var scoreTitleLab: UILabel? {
        get {
            if (_scoreTitleLab != nil) {
                return _scoreTitleLab
            }
            let tempLab = UILabel.init()
            tempLab.text = "考试成绩："
            tempLab.font = UIFont.systemFont(ofSize: 14.0)
            _scoreTitleLab = tempLab
            return _scoreTitleLab
        }
    }

    //MARK: - ------Serialize and Deserialize------

}

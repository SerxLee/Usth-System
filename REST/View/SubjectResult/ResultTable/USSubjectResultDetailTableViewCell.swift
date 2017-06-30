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
    private var _creditLab: UILabel?
    private var _typeLab: UILabel?
    private var _classIdLab: UILabel?
    
    //MARK: - ------Life Circle------
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(self.classNameLab!)
        self.contentView.addSubview(self.scoreLab!)
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
        
        self.scoreLab!.snp.makeConstraints { (make) in
            make.top.equalTo(line).offset(10.0)
            make.left.equalTo(self.contentView).offset(40.0)
            make.width.equalTo(90.0)
            make.height.equalTo(21.0)
        }
        self.creditLab!.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset((SCREEN_WIDTH - 40.0) / 2.0 + 40.0)
            make.top.equalTo(self.scoreLab!)
            make.height.equalTo(21.0)
            make.right.equalTo(self.contentView)
        }
        
        self.classIdLab!.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(40.0)
            make.top.equalTo(self.scoreLab!.snp.bottom)
            make.height.equalTo(21.0)
            make.width.equalTo((SCREEN_WIDTH - 40.0) / 2.0)
        }

        self.typeLab!.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset((SCREEN_WIDTH - 40.0) / 2.0 + 40.0)
            make.top.equalTo(self.classIdLab!)
            make.height.equalTo(21.0)
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
            tempLab.font = UIFont.systemFont(ofSize: 14.0)
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
            tempLab.font = UIFont.systemFont(ofSize: 14.0)
            _classIdLab = tempLab
            return _classIdLab
        }
    }
    //MARK: - ------Serialize and Deserialize------

}

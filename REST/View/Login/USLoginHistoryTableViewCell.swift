//
//  USLoginHistoryTableViewCell.swift
//  Usth System
//
//  Created by Serx on 2017/7/11.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit

protocol USLoginHistoryTableViewCellDelegate: NSObjectProtocol {
    func deleteBtnDidClick(selectedCell: USLoginHistoryTableViewCell)
}

class USLoginHistoryTableViewCell: UITableViewCell {

    var delegate: USLoginHistoryTableViewCellDelegate?
    
    private var _userNameLab: UILabel?
    private var _deleteBtn: UIButton?

    //MARK: - ------Life Circle------
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.userNameLab!)
        self.contentView.addSubview(self.deleteBtn!)
        self.layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ------Methods------
    func layoutPageSubviews() {
        let horizontalLine =  UIView()
        horizontalLine.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(horizontalLine)
        horizontalLine.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(self.contentView)
        }
        
        self.userNameLab!.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15.0)
            make.height.equalTo(16.0)
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.deleteBtn!.snp.left)
        }
        self.deleteBtn!.snp.makeConstraints { (make) in
            make.height.equalTo(44.0)
            make.width.equalTo(30.0)
            make.right.equalTo(self.contentView).offset(-10.0)
            make.centerY.equalTo(self.contentView)
        }
    }
    //MARK: - ------Delegate View------
    
    //MARK: - ------Delegate Model------
    
    //MARK: - ------Delegate Table------
    
    //MARK: - ------Delegate Other------
    
    //MARK: - ------Event Response------
    func deleteBtnAction() {
        self.delegate!.deleteBtnDidClick(selectedCell: self)
    }
    
    //MARK: - ------Getters and Setters------
    var userNameLab: UILabel? {
        get {
            if _userNameLab != nil {
                return _userNameLab
            }
            let label = UILabel()
            label.textAlignment = .left
            label.textColor = UIColor.black
            label.font = UIFont.init(name: "Avenir-Heavy", size: 15.0)
            
            _userNameLab = label
            return _userNameLab
        }
    }
    
    var deleteBtn: UIButton? {
        get {
            if _deleteBtn != nil  {
                return _deleteBtn
            }
            let btn = UIButton.init()
            btn.setTitle("\u{e60c}", for: UIControlState.normal)
            btn.setTitleColor(UIColor.gray, for: UIControlState.normal)
            btn.titleLabel?.font = UIFont.init(name: "iconFont", size: 20.0)
            btn.addTarget(self, action: #selector(self.deleteBtnAction), for: UIControlEvents.touchUpInside)
            
            _deleteBtn = btn
            return _deleteBtn
        }
    }
    //MARK: - ------Serialize and Deserialize------

}

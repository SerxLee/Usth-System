//
//  USSubjectResultTableViewCell.swift
//  Usth System
//
//  Created by Serx on 2017/5/21.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol USSubjectResultTableViewCellDelegate: NSObjectProtocol {
    
}

class USSubjectResultTableViewCell: UITableViewCell {
    
    weak var delegate: USSubjectResultTableViewCellDelegate?

    private var _classNameLab: UILabel?
    private var _scoreLab: UILabel?

    //MARK: - ------Life Circle------
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(self.classNameLab!)
        self.contentView.addSubview(self.scoreLab!)
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
        self.scoreLab!.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-10.0)
            make.width.equalTo(40.0)
        }
        self.classNameLab!.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(10.0)
            make.right.equalTo(self.scoreLab!.snp.left)
        }
    }
    
    //MARK: - ------Delegate View------
    
    //MARK: - ------Delegate Model------
    
    //MARK: - ------Delegate Table------
    
    //MARK: - ------Delegate Other------
    
    //MARK: - ------Event Response------
    
    //MARK: - ------Getters and Setters------
    var classNameLab: UILabel? {
        get {
            if (_classNameLab != nil) {
                return _classNameLab
            }
            let tempLab = UILabel.init()
            tempLab.font = UIFont.systemFont(ofSize: 14)
            
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
            tempLab.font = UIFont.systemFont(ofSize: 14)
            tempLab.textAlignment = .right
            _scoreLab = tempLab
            return _scoreLab
        }
    }
    //MARK: - ------Serialize and Deserialize------

}

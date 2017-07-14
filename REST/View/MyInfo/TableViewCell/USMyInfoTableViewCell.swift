//
//  USMyInfoTableViewCell.swift
//  Usth System
//
//  Created by Serx on 2017/7/14.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit

class USMyInfoTableViewCell: UITableViewCell {

    private var _operationNameLab: UILabel?
    
    //MARK: - ------Life Circle------
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.operationNameLab!)
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
        self.operationNameLab!.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15.0)
            make.right.equalTo(self.contentView)
            make.top.bottom.equalTo(self.contentView)
        }
    }
    
    func fillLabel(with Str: String) {
        let attributeStr = NSMutableAttributedString.init(string: Str)
        attributeStr.setAttributes([NSFontAttributeName: UIFont.init(name: "iconfont", size: 18.0) as Any, NSBaselineOffsetAttributeName: 2.0], range: NSRange.init(location: 0, length: 1))
        attributeStr.setAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 14.0) as Any, NSBaselineOffsetAttributeName: 4.0], range: NSRange.init(location: 3, length: 4))
        
        self.operationNameLab?.attributedText = attributeStr
    }
    
    func showBottomLine() {
        let horizontalLine =  UIView()
        horizontalLine.backgroundColor = UIColor.lineGray()
        self.contentView.addSubview(horizontalLine)
        horizontalLine.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.equalTo(15)
            make.right.equalTo(0.0)
            make.bottom.equalTo(self.contentView)
        }
    }
    //MARK: - ------Delegate View------
    
    //MARK: - ------Delegate Model------
    
    //MARK: - ------Delegate Table------
    
    //MARK: - ------Delegate Other------
    
    //MARK: - ------Event Response------
    
    //MARK: - ------Getters and Setters------
    var operationNameLab: UILabel? {
        get {
            if _operationNameLab != nil {
                return _operationNameLab
            }
            let label: UILabel = UILabel()
            label.textAlignment = .left
            _operationNameLab = label
            return _operationNameLab
        }
    }

    //MARK: - ------Serialize and Deserialize------

}

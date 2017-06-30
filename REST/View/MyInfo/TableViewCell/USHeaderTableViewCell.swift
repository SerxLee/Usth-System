//
//  USHeaderTableViewCell.swift
//  Usth System
//
//  Created by Serx on 2017/5/24.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit

class USHeaderTableViewCell: UITableViewCell {

    var userHeaderImg: UIImageView?
    var stuNameLab: UILabel?
    var classNameLab: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.userHeaderImg!)
        self.contentView.addSubview(self.stuNameLab!)
        self.contentView.addSubview(self.classNameLab!)
        
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
    
    func layoutPageSubviews() {
        self.userHeaderImg!.snp.makeConstraints { (make) in
            make.height.equalTo(20.0)
            make.width.equalTo(20.0)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.left.equalTo(self.contentView).offset(20.0)
        }
        
        self.stuNameLab!.snp.makeConstraints { (make) in
            
        }
    }

}

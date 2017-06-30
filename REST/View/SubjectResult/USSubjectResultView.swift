//
//  USSubjectResultView.swift
//  Usth System
//
//  Created by Serx on 2017/5/16.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol USSubjectResultViewDelegate: NSObjectProtocol {
    @objc optional func limFunc()
}

class USSubjectResultView: UIView {
    
    weak var delegete: USSubjectResultViewDelegate?

    //MARK: - ------Life Circle------
    init() {
        super.init(frame: CGRect.zero)
        self.layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ------Methods------
    func layoutPageSubviews() {
        
    }
    //MARK: - ------Delegate View------
    
    //MARK: - ------Delegate Model------
    
    //MARK: - ------Delegate Table------
    
    //MARK: - ------Delegate Other------
    
    //MARK: - ------Event Response------
    
    //MARK: - ------Getters and Setters------

    //MARK: - ------Serialize and Deserialize------


}

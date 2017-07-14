//
//  USPlaceHolderView.swift
//  Usth System
//
//  Created by Serx on 2017/7/12.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit

protocol USPlaceHolderViewDelegate: NSObjectProtocol {
    func reloadBtnAction()
}

enum PlaceHolderViewType {
    case NotData
    case NotNetwork
    case LoadFail
    case NotComment
    case NotHistoryComment
}

class USPlaceHolderView: UIView {
    
    weak var delegate: USPlaceHolderViewDelegate!

    private var placeHolderViewType: PlaceHolderViewType!
    private var messageStr: String!
    
    private var _imgView: UIImageView?
    private var _messageLab: UILabel?
    private var _loadView: UIView?
    private var _loadBtn: UIButton?
    
    //MARK: - ------Life Circle------
    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(self.imgView!)
        self.addSubview(self.messageLab!)
        self.addSubview(self.loadBtn!)
        self.layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - ------Methods------
    func loadPlaceHolderView(with messageStr: String, and placeHolderViewType: PlaceHolderViewType) {
        self.placeHolderViewType = placeHolderViewType
        self.messageStr = messageStr
        self.messageLab?.text = messageStr
        if placeHolderViewType == .NotNetwork {
            self.imgView!.image = UIImage.init(named: "NotNetwork")
        } else if placeHolderViewType == .NotData {
            self.imgView!.image = UIImage.init(named: "NotFounded")
        } else if placeHolderViewType == .NotComment {
            self.imgView!.image = UIImage.init(named: "safa")
            self.loadBtn!.alpha = 0.0
        } else if placeHolderViewType == .NotHistoryComment {
            self.imgView!.image = UIImage.init(named: "LoadFail")
            self.loadBtn!.alpha = 0.0
        }
    }
    
    func layoutPageSubviews() {
        self.imgView?.snp.makeConstraints({ (make) in
            make.height.equalTo(145.0)
            make.width.equalTo(145.0)
            make.left.equalTo(self).offset((SCREEN_WIDTH - 145.0) / 2.0)
            make.top.equalTo(self).offset((SCREEN_HEIGHT - 145.0 - 50.0 - 40.0) / 2.0 - 50.0)
        })
        self.messageLab?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.imgView!.snp.bottom)
            make.width.equalTo(SCREEN_WIDTH - 20.0)
            make.left.equalTo(self).offset(10.0)
            make.height.equalTo(50.0)
        })
        self.loadBtn?.snp.makeConstraints({ (make) in
            make.width.equalTo(180.0)
            make.height.equalTo(40.0)
            make.top.equalTo(self.messageLab!.snp.bottom)
            make.left.equalTo(self).offset((SCREEN_WIDTH - 180.0) / 2.0)
        })
    }
    //MARK: - ------Delegate View------
    
    //MARK: - ------Delegate Model------
    
    //MARK: - ------Delegate Table------
    
    //MARK: - ------Delegate Other------
    
    //MARK: - ------Event Response------
    func btnHightLight(sender: UIButton) {
        sender.backgroundColor = UIColor.myinforDownBlue()
    }
    
    func btnNomal(sender: UIButton) {
        sender.backgroundColor = UIColor.sexBlue()
        self.delegate.reloadBtnAction()
    }
    
    //MARK: - ------Getters and Setters------
    var imgView: UIImageView? {
        get {
            if _imgView != nil {
                return _imgView
            }
            let View = UIImageView()
            View.contentMode = .scaleAspectFit
            
            _imgView = View
            return _imgView
        }
    }
    
    var messageLab: UILabel? {
        get {
            if _messageLab != nil {
                return _messageLab
            }
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textAlignment = .center
            label.textColor = UIColor.lightGray
            
            _messageLab = label
            return _messageLab
        }
    }
    
    var loadBtn: UIButton? {
        get {
            if _loadBtn != nil {
                return _loadBtn
            }
            let button = UIButton()
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            button.setTitle("重新加载", for: UIControlState.normal)
            button.backgroundColor = UIColor.sexBlue()
            button.setTitleColor(UIColor.white, for: UIControlState.normal)
            button.layer.cornerRadius = 5.0
            button.addTarget(self, action: #selector(self.btnHightLight(sender:)), for: UIControlEvents.touchDown)
            button.addTarget(self, action: #selector(self.btnNomal(sender:)), for: UIControlEvents.touchUpInside)
            
            _loadBtn = button
            return _loadBtn
        }
    }
    //MARK: - ------Serialize and Deserialize------

}

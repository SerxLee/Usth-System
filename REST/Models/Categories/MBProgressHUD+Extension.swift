//
//  MBProgressHUD+Extension.swift
//  Usth System
//
//  Created by Serx on 2017/7/9.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import MBProgressHUD

let kMBProgressHUDMsgLoading: String = "请稍后..."
let kMBProgressHUDMsgLoadError: String = "加载失败"
let kMBProgressHUDMsgLoadSuccessful: String = "加载成功"
let kMBProgressHUDMsgNoMoreData: String = "没有更多数据了"
let kMBProgressHUDHideTimeInterval: TimeInterval = 1.2

let FONT_SIZE: CGFloat = 14.0
let OPACITY: CGFloat = 0.85

enum USMBProgressHUDMsgType {
    case Successful
    case Error
    case Warning
    case Info
}

extension MBProgressHUD {
    func us_showHUD(addTo view: UIView, title: String?) -> MBProgressHUD {
        let hud: MBProgressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.font = UIFont.systemFont(ofSize: FONT_SIZE)
        hud.label.text = title!
        hud.bezelView.color = UIColor.white.withAlphaComponent(OPACITY)
        return hud
    }
    
    func us_showHUD(addTo view: UIView, title: String?, animated: Bool) -> MBProgressHUD {
        let hud: MBProgressHUD = MBProgressHUD.showAdded(to: view, animated: animated)
        hud.label.font = UIFont.systemFont(ofSize: FONT_SIZE)
        hud.label.text = title!
        hud.bezelView.color = UIColor.white.withAlphaComponent(OPACITY)
        return hud
    }
    
    func us_hide(with title: String?, afterSecond: TimeInterval) -> Void {
        if (title != nil) {
            self.label.text = title!
            self.mode = .text
        }
        self.hide(animated: true, afterDelay: afterSecond)
    }
    
    func us_hide(afterSecond: TimeInterval) -> Void {
        self.hide(animated: true, afterDelay: afterSecond)
    }
    
    func us_hide(with title: String?, afterSecond: TimeInterval, msgType: USMBProgressHUDMsgType) -> Void {
        self.label.text = title!
        self.mode = .customView
        if let imageName = self.imageName(with: msgType){
            self.customView = UIImageView.init(image: UIImage.init(named: imageName))
        }
        self.hide(animated: true, afterDelay: afterSecond)
    }
    
    func us_showTitle(with title: String?, view: UIView, afterSecond: TimeInterval) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.label.font = UIFont.systemFont(ofSize: FONT_SIZE)
        hud.label.text = title!
        hud.bezelView.color = UIColor.white.withAlphaComponent(OPACITY)
        hud.hide(animated: true, afterDelay: afterSecond)
        return hud
    }
    
    func us_showTitle(with title: String?, view: UIView, afterSecond: TimeInterval, msgType: USMBProgressHUDMsgType) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView
        hud.label.font = UIFont.systemFont(ofSize: FONT_SIZE)
        hud.label.text = title!
        if let imageName = self.imageName(with: msgType) {
            hud.customView = UIImageView.init(image: UIImage.init(named: imageName))
        }
        hud.hide(animated: true, afterDelay: afterSecond)
        return hud
    }
    
    func imageName(with MsgType: USMBProgressHUDMsgType) -> String? {
        var imageName: String? = nil
        if (MsgType == .Successful) {
            imageName = "hud_success"
        } else if (MsgType == .Error) {
            imageName = "hud_error"
        } else if (MsgType == .Warning) {
            imageName = "hud_warning"
        } else if (MsgType == .Info) {
            imageName = "hud_info"
        }
        return imageName
    }
    
    func us_showDeterminateHUD(to view: UIView) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .determinateHorizontalBar
        hud.animationType = .zoom
        hud.label.text = kMBProgressHUDMsgLoading
        hud.label.font = UIFont.systemFont(ofSize: FONT_SIZE)
        return hud
    }
    
    func us_showAnnularDeterminateHUD(to view: UIView, progressValue value: Float) -> MBProgressHUD {
        let hud = MBProgressHUD.init(view: view)
        view.addSubview(hud)
        hud.mode = .annularDeterminate
        hud.animationType = .zoom
        hud.label.text = "正在载入..."
        hud.progress = value
        return hud
    }
}

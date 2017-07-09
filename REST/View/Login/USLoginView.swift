//
//  USLoginView.swift
//  Usth System
//
//  Created by Serx on 2017/5/19.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol USLoginViewDelegate: NSObjectProtocol {
    
    func loginViewClickConfirmBtn(_ userName: String, password: String)
}

class USLoginView: UIView, UITextFieldDelegate {
    
    weak var delegate: USLoginViewDelegate?

    let formViewHeight = 90
    
    var historyTableView: UITableView!
    
    private var _userName: UITextField?
    private var _password: UITextField?
    private var _formView: UIView?
    private var _titleLabel: UILabel?
    private var _confirmBtn: UIButton?
    
    //MARK: - ------Life Circle------
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.sexBlue()
        self.addSubview(self.titleLabel!)
        self.addSubview(self.formView!)
        self.addSubview(self.confirmBtn!)
        self.layoutPageSubviews()
        
        let tapGestrue: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.tapAction(gestrue:)))
        self.addGestureRecognizer(tapGestrue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        if (self.window != nil) {
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillShow(aNotification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        }
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        if (self.window == nil) {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        }
    }
    
    //MARK: - ------Methods------
    func layoutPageSubviews() {
        self.titleLabel!.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.formView!.snp.top).offset(-20)
            make.centerX.equalTo(0)
            make.height.equalTo(44)
        }
        
        self.formView!.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.height.equalTo(formViewHeight)
            make.centerX.equalTo(self)
            make.width.equalTo(224)
        }
        
        self.confirmBtn!.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.width.equalTo(self.formView!)
            make.height.equalTo(44.0)
            make.top.equalTo(self.formView!.snp.bottom).offset(20.0)
        }
    }
    
    func keyBoardWillShow(aNotification: Notification) {
        let userInfo = aNotification.userInfo
        let aValue: NSValue = userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardRect: CGRect = aValue.cgRectValue
        
        if (keyboardRect.size.height <= 0) {
            return
        }
        let keyboardHeight = keyboardRect.size.height
        self.formView!.snp.updateConstraints { (make) in
            let viewToTop = (SCREEN_HEIGHT - 64 - keyboardHeight - 268.0) / 2; //320为弹出的View高度
            let moveLen = (SCREEN_HEIGHT - 64) / 2 - viewToTop - 134.0;
            make.centerY.equalTo(self).offset(-moveLen)
        }
        UIView.animate(withDuration: 0.3) { 
            self.layoutIfNeeded()
        }
        
    }
    
    func hideKeyboard() {
        if (self.userName!.isFirstResponder) {
            self.userName!.resignFirstResponder()
        }
        if (self.passWord!.isFirstResponder) {
            self.passWord!.resignFirstResponder()
        }
        self.formView!.snp.updateConstraints { (make) in
            make.centerY.equalTo(self)
        }
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    //MARK: - ------Delegate View------
    
    //MARK: - ------Delegate Model------
    
    //MARK: - ------Delegate Table------
    
    //MARK: - ------Delegate Other------
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text == "") {
            return false
        }
        switch textField.returnKeyType {
        case .go:
            self.confirmBtnDidClick()
        default:
            self.userName?.resignFirstResponder()
            self.passWord?.becomeFirstResponder()
        }
        return true
    }
    
    
    
    //MARK: - ------Event Response------
    func confirmBtnDidClick() {
        self.hideKeyboard()
        self.delegate!.loginViewClickConfirmBtn(self.userName!.text!, password: self.passWord!.text!)
    }
    
    func tapAction(gestrue: UITapGestureRecognizer) {
        self.hideKeyboard()
    }
    //MARK: - ------Getters and Setters------
    var titleLabel: UILabel? {
        get {
            if (_titleLabel != nil) {
                return _titleLabel
            }
            let label: UILabel = UILabel()
            label.text = "URP综合教教务系统"
            label.textColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 28)

            _titleLabel = label
            return _titleLabel
        }
        set {
            _titleLabel = newValue
        }
    }

    
    var formView: UIView? {
        get {
            if (_formView != nil) {
                return _formView
            }
            let view = UIView()
            view.layer.borderWidth = 0.5
            view.layer.borderWidth = 0.5
            view.layer.borderColor = UIColor.lightGray.cgColor
            view.backgroundColor = UIColor.white
            view.layer.cornerRadius = 5
            
            let horizontalLine =  UIView()
            horizontalLine.backgroundColor = UIColor.lightGray
            view.addSubview(horizontalLine)
            horizontalLine.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(0.5)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.centerY.equalTo(view)
            }
            
            view.addSubview(self.userName!)
            view.addSubview(self.passWord!)
            self.userName!.snp.makeConstraints { (make) in
                make.left.equalTo(view).offset(15)
                make.right.equalTo(view).offset(-15)
                make.height.equalTo(44)
                make.centerY.equalTo(view.snp.centerY).offset(-formViewHeight/4)
            }
            self.passWord!.snp.makeConstraints { (make) in
                make.left.equalTo(view).offset(15)
                make.right.equalTo(view).offset(-15)
                make.height.equalTo(44)
                make.centerY.equalTo(0).offset(formViewHeight/4)
            }

            _formView = view
            return _formView
        }
        set {
            _formView = newValue
        }
    }
    
    var confirmBtn:UIButton? {
        get {
            if (_confirmBtn != nil) {
                return _confirmBtn
            }
            let btn = UIButton()
            btn.setTitle("登陆", for: UIControlState.normal)
            btn.setTitleColor(UIColor.black, for: UIControlState.normal)
            btn.layer.cornerRadius = 5
            btn.backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.5)
            btn.addTarget(self, action: #selector(self.confirmBtnDidClick), for: .touchUpInside)
            _confirmBtn = btn
            return _confirmBtn
        }
        set {
            _confirmBtn = newValue
        }
    }

    
    var userName: UITextField? {
        get {
            if (_userName != nil) {
                return _userName
            }
            let textf = UITextField()
            textf.delegate = self
            textf.placeholder = "学号"
            textf.tag = 100
            textf.leftView = UIView(frame:CGRect.init(x: 0, y: 0, width: 44, height: 44))
            textf.leftViewMode = UITextFieldViewMode.always
            textf.returnKeyType = UIReturnKeyType.next
            
            let imgLock1 =  UIImageView(frame:CGRect.init(x: 11, y: 11, width: 22, height: 22))
            imgLock1.image = UIImage(named:"userImage")
            imgLock1.isUserInteractionEnabled = true
            textf.leftView?.addSubview(imgLock1)
            
            _userName = textf
            return _userName
        }
        set {
            _userName = newValue
        }
    }
    
    var passWord: UITextField? {
        get {
            if (_password != nil) {
                return _password
            }
            let textf = UITextField()
            textf.delegate = self
            textf.placeholder = "密码"
            textf.tag = 101
            textf.leftView = UIView(frame:CGRect.init(x: 0, y: 0, width: 44, height: 44))
            textf.leftViewMode = UITextFieldViewMode.always
            textf.returnKeyType = UIReturnKeyType.go
            textf.isSecureTextEntry = true
            
            let imgLock2 =  UIImageView(frame:CGRect.init(x: 11, y: 11, width: 22, height: 22))
            imgLock2.image = UIImage(named:"psdImage")
            imgLock2.isUserInteractionEnabled = true
            textf.leftView?.addSubview(imgLock2)
            
            _password = textf
            return _password
        }
        set {
            _password = newValue
        }
    }

    

    //MARK: - ------Serialize and Deserialize------


}

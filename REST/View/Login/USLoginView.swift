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
    func loginViewDeleteRecord(with record: USLoginHistory)
}

fileprivate let loginHistoryTableCellIdentifier: String = "loginHistoryTableCellIdentifier"
fileprivate let HISTORY_ROWHEIGHT: Int = 44

class USLoginView: UIView, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, USLoginHistoryTableViewCellDelegate {
    
    weak var delegate: USLoginViewDelegate?

    let formViewHeight: CGFloat = 90.0
    
    private var _historyTableView: UITableView!
    private var historyHeightConstraint: Constraint?
    var loginHistoryArr: Array<Any>?
    private var matchResultArr: Array<Any>? = []
    private var isHistoryTableShow: Bool = false
    private var isSelectedFromHistory: Bool = false
    private var isClickPullDown: Bool = false
    
    private var pullDownBtn: UIButton!
    private var _userName: UITextField?
    private var _password: UITextField?
    private var _formView: UIView?
    private var _titleLabel: UILabel?
    private var _confirmBtn: UIButton?
    
    
    private lazy var bottomLab: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "黑龙江科技大学版"
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - ------Life Circle------
    init(with loginHistoryArr: Array<Any>?) {
        super.init(frame: CGRect.zero)
        self.loginHistoryArr = loginHistoryArr
        self.backgroundColor = UIColor.sexBlue()
        self.addSubview(self.bottomLab)
        self.addSubview(self.titleLabel!)
        self.addSubview(self.formView!)
        self.addSubview(self.confirmBtn!)
        self.addSubview(self.historyTableView!)
        let tapGestrue: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.tapAction(gestrue:)))
        tapGestrue.delegate = self
        self.addGestureRecognizer(tapGestrue)
        self.layoutPageSubviews()
        
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
            make.centerY.equalTo(self).offset(-SCREEN_HEIGHT / 7.0)
            make.height.equalTo(formViewHeight)
            make.centerX.equalTo(self)
            make.width.equalTo(264)
        }
        
        self.confirmBtn!.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.width.equalTo(self.formView!)
            make.height.equalTo(44.0)
            make.top.equalTo(self.formView!.snp.bottom).offset(20.0)
        }
        
        self.historyTableView!.snp.makeConstraints { (make) in
            make.left.equalTo(self.formView!.snp.left)
            make.right.equalTo(self.formView!.snp.right)
            make.top.equalTo(self.formView!.snp.top).offset(formViewHeight / 2.0 + 1.0)
            self.historyHeightConstraint = make.height.equalTo(0).constraint
        }
        
        self.bottomLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(15.0)
            make.bottom.equalTo(self).offset(-30.0)
        }
    }
    
    func keyBoardWillShow(aNotification: Notification) {
        let userInfo = aNotification.userInfo
        let aValue: NSValue = userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardRect: CGRect = aValue.cgRectValue
        if (keyboardRect.size.height <= 0) {
            return
        }
        if isHistoryTableShow {
            self.hideHistoryTableView()
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
            make.centerY.equalTo(self).offset(-SCREEN_HEIGHT / 7.0)
        }
        if self.isHistoryTableShow {
            self.hideHistoryTableView()
        } else {
            UIView.animate(withDuration: 0.3, animations: { 
                self.layoutIfNeeded()
            })
        }
    }
    
    func changePullDownBtnState() {
        self.pullDownBtn.setTitle(self.isHistoryTableShow ? "\u{e74a}" : "\u{e749}", for: UIControlState.normal)
    }
    
    func hideHistoryTableView() {
        if self.isHistoryTableShow {
            self.changePullDownBtnState()
            UIView.animate(withDuration: 0.3, animations: {
                self.historyHeightConstraint?.update(offset: 0)
                self.layoutIfNeeded()
            })
            self.isHistoryTableShow = false
            self.isClickPullDown = false
        }
    }

    func showHistoryTableView(with height: CGFloat) {
        if !self.isHistoryTableShow {
            self.changePullDownBtnState()
            UIView.animate(withDuration: 0.3, animations: {
                self.historyHeightConstraint?.update(offset: height)
                self.layoutIfNeeded()
            })
            self.isHistoryTableShow = true
        } else {
            UIView.animate(withDuration: 0.3, animations: { 
                self.historyHeightConstraint?.update(offset: height)
                self.layoutIfNeeded()
            })
        }
    }
    
    func filterLoginHistory(with str: String) {
        if self.loginHistoryArr == nil {
            if self.matchResultArr!.count > 0 && self.isHistoryTableShow {
                self.hideHistoryTableView()
            }
            return
        }
        self.matchResultArr = self.loginHistoryArr?.filter({ (loginRecord) -> Bool in
            let record = loginRecord as! USLoginHistory
            let strMatch = record.userNameStr.range(of: str, options: .caseInsensitive)
            return strMatch != nil
        } )
        self.calculateAndShowHistoryTableView()
    }
    
    func calculateAndShowHistoryTableView() {
        if (self.isClickPullDown) {
            self.matchResultArr = self.loginHistoryArr
        }
        
        if (self.matchResultArr!.count > 0) {
            if (self.matchResultArr!.count <= 4) {
                if self.matchResultArr!.count == 1 {
                    let tempRecord: USLoginHistory = self.matchResultArr![0] as! USLoginHistory
                    if tempRecord.userNameStr == self.userName?.text {
                        self.matchResultArr = []
                    }
                }
                let temp = self.matchResultArr!.count * HISTORY_ROWHEIGHT
                self.showHistoryTableView(with: CGFloat(temp))
            } else {
                self.showHistoryTableView(with: CGFloat(4 * HISTORY_ROWHEIGHT))
            }
            self.historyTableView!.reloadData()
        }
        else {
            self.hideHistoryTableView()
        }
    }
    //MARK: - ------Delegate View------
    func deleteBtnDidClick(selectedCell: USLoginHistoryTableViewCell) {
        let indexPath: IndexPath = self.historyTableView!.indexPath(for: selectedCell)!
        let row = indexPath.row
        self.delegate?.loginViewDeleteRecord(with: self.matchResultArr![row] as! USLoginHistory)
        self.filterLoginHistory(with: self.userName!.text!)
    }
    //MARK: - ------Delegate Model------
    
    //MARK: - ------Delegate Table------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchResultArr!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: loginHistoryTableCellIdentifier) as! USLoginHistoryTableViewCell
        
        let record: USLoginHistory = self.matchResultArr![indexPath.row] as! USLoginHistory
        cell.delegate = self
        cell.userNameLab?.text = record.userNameStr
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let record: USLoginHistory = self.matchResultArr![indexPath.row] as! USLoginHistory
        self.isSelectedFromHistory = true
        self.userName?.text = record.userNameStr
        self.passWord?.text = record.passwordStr
        self.hideKeyboard()
    }
    
    //MARK: - ------Delegate Other------
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: self)
        return !self.historyTableView!.frame.contains(touchPoint)
    }
    
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
            self.hideHistoryTableView()
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
    
    func userNameChange(textFiled: UITextField) {
        if isSelectedFromHistory {
            self.passWord?.text = ""
        }
        if let str = textFiled.text {
            if str != "" {
                self.isClickPullDown = false
                self.filterLoginHistory(with: str)
            }
            else {
                self.hideHistoryTableView()
            }
        }
    }
    
    func pullDownBtnAction() {
        if !isHistoryTableShow {
            if self.loginHistoryArr == nil { return }
            self.isClickPullDown = true
            self.calculateAndShowHistoryTableView()
        } else {
            self.hideHistoryTableView()
        }
    }
    
    //MARK: - ------Getters and Setters------
    var titleLabel: UILabel? {
        get {
            if (_titleLabel != nil) {
                return _titleLabel
            }
            let label: UILabel = UILabel()
            label.text = "URP综合教务系统"
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
//            view.layer.borderWidth = 0.5
//            view.layer.borderColor = UIColor.lightGray.cgColor
            view.backgroundColor = UIColor.white
            view.layer.cornerRadius = 5
            
            let horizontalLine =  UIView()
            horizontalLine.backgroundColor = UIColor.lightGray
            view.addSubview(horizontalLine)
            view.addSubview(self.userName!)
            view.addSubview(self.passWord!)
            self.pullDownBtn = UIButton()
            self.pullDownBtn.setTitle("\u{e74a}", for: UIControlState.normal)
            self.pullDownBtn.titleLabel?.font = UIFont.init(name: "iconFont", size: 25.0)
            self.pullDownBtn.titleLabel?.textAlignment = .center
            self.pullDownBtn.setTitleColor(self.loginHistoryArr == nil ? UIColor.lightGray: UIColor.black, for: UIControlState.normal)
            self.pullDownBtn.isEnabled = self.loginHistoryArr == nil ? false: true
            self.pullDownBtn.addTarget(self, action: #selector(self.pullDownBtnAction), for: UIControlEvents.touchUpInside)
            view.addSubview(self.pullDownBtn)
            
            horizontalLine.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(0.5)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.centerY.equalTo(view)
            }
            self.userName!.snp.makeConstraints { (make) in
                make.left.equalTo(view).offset(15)
                make.right.equalTo(self.pullDownBtn.snp.left)
                make.height.equalTo(44)
                make.centerY.equalTo(view.snp.centerY).offset(-formViewHeight/4.0)
            }
            self.passWord!.snp.makeConstraints { (make) in
                make.left.equalTo(view).offset(15)
                make.right.equalTo(view).offset(-15)
                make.height.equalTo(44)
                make.centerY.equalTo(0).offset(formViewHeight/4.0)
            }

            self.pullDownBtn.snp.makeConstraints { (make) in
                make.centerY.equalTo(self.userName!)
                make.height.equalTo(30.0)
                make.width.equalTo(30.0)
                make.right.equalTo(view).offset(-10.0)
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
            textf.clearButtonMode = .whileEditing
            textf.addTarget(self, action: #selector(self.userNameChange(textFiled:)), for: UIControlEvents.editingChanged)
            
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

    var historyTableView: UITableView? {
        get {
            if _historyTableView != nil {
                return _historyTableView
            }
            let tableView = UITableView()
            tableView.register(USLoginHistoryTableViewCell.self, forCellReuseIdentifier: loginHistoryTableCellIdentifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
            tableView.layer.cornerRadius = 5.0
            tableView.backgroundColor = UIColor.white
            tableView.separatorStyle = .none
            tableView.rowHeight = CGFloat(HISTORY_ROWHEIGHT)
            
            _historyTableView = tableView
            return _historyTableView
        }
    }
    

    //MARK: - ------Serialize and Deserialize------


}

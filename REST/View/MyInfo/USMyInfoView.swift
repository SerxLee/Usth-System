//
//  USMyInfoView.swift
//  Usth System
//
//  Created by Serx on 2017/5/16.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit
import AFNetworking

protocol USMyInfoViewDelegate: NSObjectProtocol {
    func myInfoViewHandleHeaderImgViewClick()
    func myInfoViewCancelLogin()
    func myInfoViewAboutUs()
    func myInfoViewCleanCache()
    func myInfoViewSupportAdvise()
}

private let myInfoTableViewCellIdentifier: String = "myInfoTableViewCellIdentifier"

class USMyInfoView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: USMyInfoViewDelegate?
    
    private var _headerView: UIView?
    private var _headerImgView: UIImageView?
    private var _stuNameLab: UILabel?
    private var _classNameLab: UILabel?
    private var _cancelBtn: UIButton?
    
    
    private var _tableView: UITableView?
    private var waveView: USWaveView!
    //MARK: - ------Life Circle------
    init() {
        super.init(frame: CGRect.zero)
    }
    
    convenience init(_ info: USMyInfo?) {
        self.init()
        self.addSubview(self.tableView!)
        self.addSubview(self.headerView!)
        self.layoutPageSubviews()
        
        self.reloadInfoWith(info)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - ------Methods------
    func layoutPageSubviews() {
        self.headerView!.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(200.0)
        }
        
        self.tableView!.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView!.snp.bottom).offset(-1.0)
            make.left.right.bottom.equalTo(self)
        }
    }
    
    func reloadInfoWith(_ myInfo: USMyInfo?) {
        if (myInfo != nil) {
            self.stuNameLab!.text = myInfo!.stu_name
            self.classNameLab!.text = myInfo!.stu_class
            if (myInfo?.stu_header != "") {
                self.headerImgView!.setImageWith(URL.init(string: myInfo!.stu_header)!, placeholderImage: UIImage.init(named: "Default-Header"))
            } else {
                self.headerImgView?.image = UIImage.init(named: "Default-Header")
            }
            
        }
    }
    
    //MARK: - ------Delegate View------
    
    //MARK: - ------Delegate Model------
    
    //MARK: - ------Delegate Table------
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else if (section == 1) {
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myInfoTableViewCellIdentifier, for: indexPath) as! USMyInfoTableViewCell
        if (indexPath.section == 0) {
            cell.fillLabel(with: "\u{e60d}  清理缓存")
        } else {
            switch indexPath.row {
            case 0:
                cell.fillLabel(with: "\u{e8a1}  意见反馈")
                cell.showBottomLine()
                break
            case 1:
                cell.fillLabel(with: "\u{e896}  关于设计")
                cell.showBottomLine()
                break
            default:
                cell.fillLabel(with: "\u{e895}  退出登录")
                break
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 0.01
        }
        return 12.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 1.0))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 1.0))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.section == 0) {
            self.delegate?.myInfoViewCleanCache()
        } else {
            switch indexPath.row {
            case 0:
                self.delegate?.myInfoViewSupportAdvise()
                break
            case 1:
                self.delegate?.myInfoViewAboutUs()
                break
            default:
                self.delegate?.myInfoViewCancelLogin()
                break
            }
        }
    }
    //MARK: - ------Delegate Other------
    
    //MARK: - ------Event Response------
    func handleHeaderImageViewTapGesture(sender: UITapGestureRecognizer) {
        self.delegate!.myInfoViewHandleHeaderImgViewClick()
    }
    
    //MARK: - ------Getters and Setters------
    var headerView: UIView? {
        get {
            if (_headerView != nil) {
                return _headerView
            }
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 200.0))
            view.backgroundColor = UIColor.sexBlue()
            
            view.addSubview(self.headerImgView!)
            view.addSubview(self.stuNameLab!)
            view.addSubview(self.classNameLab!)
            self.headerImgView!.snp.makeConstraints { (make) in
                make.height.equalTo(60.0)
                make.width.equalTo(60.0)
                make.centerX.equalTo(view)
                make.centerY.equalTo(view).offset(-20.0)
            }

            self.stuNameLab!.snp.makeConstraints { (make) in
                make.height.equalTo(20.0)
                make.top.equalTo(self.headerImgView!.snp.bottom).offset(10.0)
                make.left.right.equalTo(view)
                
            }
            self.classNameLab!.snp.makeConstraints { (make) in
                make.height.equalTo(20.0)
                make.top.equalTo(self.stuNameLab!.snp.bottom).offset(5.0)
                make.left.right.equalTo(view)
            }
            
            self.waveView = USWaveView.init(frame: CGRect.init(x: 0, y: 190.0, width: SCREEN_WIDTH, height: 10.0))
            view.addSubview(self.waveView)
            self.waveView.startWave()
            
            _headerView = view;
            return _headerView
        }
        set {
            _headerView = newValue
        }
    }
    
    var tableView: UITableView? {
        get {
            if (_tableView != nil) {
                return _tableView
            }
            let tableV = UITableView.init(frame: CGRect.zero, style: .grouped)
            tableV.rowHeight = 48.0
            tableV.delegate = self
            tableV.dataSource = self
            tableV.backgroundColor = UIColor.sexLightGray()
            tableV.tableFooterView = UIView()
            tableV.isScrollEnabled = false
            tableV.register(USMyInfoTableViewCell.self, forCellReuseIdentifier: myInfoTableViewCellIdentifier)
            tableV.separatorStyle = .none
            
            _tableView = tableV
            return _tableView
        }
        set {
            _tableView = newValue
        }
    }

    var headerImgView: UIImageView? {
        get {
            if (_headerImgView != nil) {
                return _headerImgView
            }
            let imgView = UIImageView.init(image: UIImage.init(named: "Default-Header"))
            imgView.backgroundColor = UIColor.white
            imgView.layer.cornerRadius = 30.0
            imgView.layer.masksToBounds = true
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.handleHeaderImageViewTapGesture(sender:)))
            imgView.addGestureRecognizer(tapGesture)
            imgView.isUserInteractionEnabled = true
            
            _headerImgView = imgView
            return _headerImgView
        }
        set {
            _headerImgView = newValue
        }
    }
    var stuNameLab: UILabel? {
        get {
            if (_stuNameLab != nil) {
                return _stuNameLab
            }
            let label = UILabel()
            label.backgroundColor = UIColor.clear
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            _stuNameLab = label
            return _stuNameLab
        }
        set {
            _stuNameLab = newValue
        }
    }
    var classNameLab: UILabel? {
        get {
            if (_classNameLab != nil) {
                return _classNameLab
            }
            let label = UILabel()
            label.backgroundColor = UIColor.clear
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            _classNameLab = label
            return _classNameLab
        }
        set {
            _classNameLab = newValue
        }
    }
    
    var cancelBtn: UIButton? {
        get {
            if (_cancelBtn != nil) {
                return _cancelBtn
            }
            let btn = UIButton.init(type: .system)
            btn.setTitle("注销登录", for: .normal)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.titleLabel?.textAlignment = .right
            btn.backgroundColor = UIColor.red
            btn.layer.cornerRadius = 5.0
            
            _cancelBtn = btn
            return _cancelBtn
        }
    }
    //MARK: - ------Serialize and Deserialize------


}

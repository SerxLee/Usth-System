//
//  USMyInfoViewController.swift
//  Usth System
//
//  Created by Serx on 2017/5/15.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit
import Qiniu
import AFNetworking
import MessageUI

class USMyInfoViewController: UIViewController, USMyInfoViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, USUploadImageOperationDelegate, USHeaderTokenDelegate, MFMailComposeViewControllerDelegate {
   
    private var _myInfoView: USMyInfoView?
    private var _uploadImageOperation: USUploadImageOperation?
    
    var myInfo: USMyInfo? = USMyInfo.getStoredUser()
    
    private var _token: USHeaderToken?
    
    //MARK: - ------Life Circle------

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.myInfoView!)
        self.layoutPageSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - ------Methods------
    func layoutPageSubviews() {
        self.myInfoView!.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    func showChangeUserHeaderAlert() {
        let userHeaderAlert = UIAlertController(title: "更换头像", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        let chooseFromPhotoAlbumAction = UIAlertAction.init(title: "从相册选择", style: .default) { (action) in
            self.chooseFromPhotoAlbum(action: action)
        }
        userHeaderAlert.addAction(chooseFromPhotoAlbumAction)
        let takePhotoFromCamera = UIAlertAction.init(title: "拍照", style: .default) { (action) in
            self.takePhotoFromCamera(action: action)
        }
        userHeaderAlert.addAction(takePhotoFromCamera)
        let canelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel,handler: nil)
        userHeaderAlert.addAction(canelAction)
        self.present(userHeaderAlert, animated: true, completion: nil)
    }
    
    func showCancelLoginAlert() {
        let notionAlert = UIAlertController(title: "请确认注销登录", message: "", preferredStyle: .alert)
        let cancelOption = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let confirmOption = UIAlertAction.init(title: "确定", style: .default) { (action) in
            self.cancelLoginAction(action: action)
        }
        notionAlert.addAction(confirmOption)
        notionAlert.addAction(cancelOption)
        self.present(notionAlert, animated: true, completion: nil)
    }
    //MARK: - ------Delegate View------
    func myInfoViewHandleHeaderImgViewClick() {
        self.token!.getHeaderToken()
        self.showChangeUserHeaderAlert()
    }
    
    func myInfoViewCleanCache() {
        let notionAlert = UIAlertController(title: "请确认清理缓存", message: "", preferredStyle: .alert)
        let cancelOption = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let confirmOption = UIAlertAction.init(title: "确定", style: .default) { (action) in
            self.cleanCache(action: action)
        }
        notionAlert.addAction(confirmOption)
        notionAlert.addAction(cancelOption)
        self.present(notionAlert, animated: true, completion: nil)
    }
    
    func myInfoViewAboutUs() {
        let aboutVC = USAboutViewController()
        self.navigationController?.pushViewController(aboutVC, animated: true)
    }
    
    func myInfoViewSupportAdvise() {
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.title = "发送意见"
        mailVC.setToRecipients(["serx.lee@gmail.com"])
        self.present(mailVC, animated: true, completion: nil)
    }
    
    func myInfoViewCancelLogin() {
        self.showCancelLoginAlert()
    }
    
    //MARK: - ------Delegate Model------
    func uploadImageSuccess(_ imgURLStr: String!) {
        self.myInfoView?.headerImgView?.setImageWith(URL.init(string: imgURLStr)!, placeholderImage: UIImage.init(named: "Default-Header"))
        let userInfo: USMyInfo = USMyInfo.getStoredUser()
        userInfo.stu_header = imgURLStr
        userInfo.store()
    }
    
    func getHeaderToken(_ token: String!) {
        UserDefaults.standard.setValue(token, forKey: "headerToken")
    }
    
    func getHeaderTokenWithError(_ error: Error!) {
        
    }
    //MARK: - ------Delegate Table------
    
    //MARK: - ------Delegate Other------
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        let newSizeImage = image.imageByScalingAndCroppingForSize(targetSize: CGSize.init(width: 100.0, height: 100.0))
        
        self.uploadImageOperation?.uploadImage(newSizeImage, withName: self.myInfo!.stu_id)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    //MARK: - ------Event Response------
    func chooseFromPhotoAlbum(action: UIAlertAction) -> Void {
        let imagePicker = UIImagePickerController()
        imagePicker.navigationBar.isTranslucent = true
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.navigationBar.lt_setBackgroundColor(UIColor.sexBlue())
        imagePicker.navigationBar.tintColor = UIColor.white
        imagePicker.title = ""
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func takePhotoFromCamera(action: UIAlertAction) -> Void {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func cancelLoginAction(action: UIAlertAction) -> Void {
        UserDefaults.standard.set(false, forKey: "userHasLogin")
        let loginVC = USLoginViewController()
        self.present(loginVC, animated: true, completion: nil)
        //FIXME: 修改登录标志
    }
    
    func cleanCache(action: UIAlertAction) -> Void {
        self.showHint(in: self.view, hint: "清理完成")
    }
    
    //MARK: - ------Getters and Setters------
    var myInfoView: USMyInfoView? {
        get {
            if (_myInfoView != nil) {
                return _myInfoView
            }
            let view = USMyInfoView.init(self.myInfo)
            view.delegate = self
            _myInfoView = view
            return _myInfoView
        }
        set {
            _myInfoView = newValue
        }
    }
    
    var token: USHeaderToken? {
        get {
            if (_token != nil ) {
                return _token
            }
            let tempToken = USHeaderToken()
            tempToken.delegate = self
            _token = tempToken
            return _token
        }
    }

    var uploadImageOperation: USUploadImageOperation? {
        get {
            if (_uploadImageOperation != nil) {
                return _uploadImageOperation
            }
            let operation = USUploadImageOperation()
            operation.delegate = self
            _uploadImageOperation = operation
            return _uploadImageOperation
        }
    }
    //MARK: - ------Serialize and Deserialize------


}

//
//  USAnalyseViewController.swift
//  Usth System
//
//  Created by Serx on 2017/5/15.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit
import Photos

class USAnalyseViewController: UIViewController {

    private var _analyseView: USAnalyseView?
    private var _rightBarBtn: UIBarButtonItem?

    private var subjectData: USErrorAndData?
    
    private var localId: String = ""

    //MARK: - ------Life Circle------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subjectData = USErrorAndData.getStoreSubjectResult(withType: "passing")
        self.view.addSubview(self.analyseView!)
        self.layoutPageSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hideBottomHairline()
        self.navigationItem.rightBarButtonItem = self.rightBarBtn
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - ------Methods------
    func layoutPageSubviews() {
        self.analyseView!.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    //MARK: - ------Delegate View------
    
    //MARK: - ------Delegate Model------
    
    //MARK: - ------Delegate Table------
    
    //MARK: - ------Delegate Other------
    
    //MARK: - ------Event Response------
    func rightBarItemAction(sender: AnyObject) {
        
        
        let image = self.analyseView!.scrollView?.capture
        PHPhotoLibrary.shared().performChanges({
            let result = PHAssetChangeRequest.creationRequestForAsset(from: image!)
            let assetPlaceholder = result.placeholderForCreatedAsset
            //保存标志符
            self.localId = assetPlaceholder!.localIdentifier
        }) { (isSuccess: Bool, error: Error?) in
            if isSuccess {
                DispatchQueue.main.async {
                    self.showHint(in: self.view, hint: "成功保存到相册")
                }
                //通过标志符获取对应的资源
                let assetResult = PHAsset.fetchAssets(
                    withLocalIdentifiers: [self.localId], options: nil)
                let asset = assetResult[0]
                let options = PHContentEditingInputRequestOptions()
                options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData)
                    -> Bool in
                    return true
                }
                
                //获取保存的原图
                PHImageManager.default().requestImage(for: asset,
                                                      targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit,
                                                      options: nil, resultHandler: { (image, _:[AnyHashable : Any]?) in
                                                        print("获取原图成功：\(image)")
                })
                //获取保存的缩略图
                PHImageManager.default().requestImage(for: asset,
                                                      targetSize: CGSize(width:100, height:100), contentMode: .aspectFit,
                                                      options: nil, resultHandler: { (image, _:[AnyHashable : Any]?) in
                                                        print("获取缩略图成功：\(image)")
                })
            } else {
                DispatchQueue.main.async {
                    self.showHint(in: self.view, hint: "保存失败")
                }
                print("保存失败：", error!.localizedDescription)
            }
        }
 
    }
    //MARK: - ------Getters and Setters------
    var analyseView: USAnalyseView? {
        get {
            if (_analyseView != nil) {
                return _analyseView
            }
            let tempView = USAnalyseView.init(self.subjectData)
            _analyseView = tempView
            return _analyseView
        }
    }

    
    var rightBarBtn: UIBarButtonItem? {
        get {
            if (_rightBarBtn != nil) {
                return _rightBarBtn
            }
            let barBtn = UIBarButtonItem.init(title: "\u{e61f}", style: .plain, target: self, action: #selector(self.rightBarItemAction(sender:)))
            barBtn.setTitleTextAttributes([NSFontAttributeName: UIFont.init(name: "iconfont", size: 25.0)!], for: .normal)
            barBtn.tintColor = UIColor.white
            
            _rightBarBtn = barBtn
            return _rightBarBtn
        }
    }
    //MARK: - ------Serialize and Deserialize------


}

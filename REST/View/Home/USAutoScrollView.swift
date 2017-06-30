//
//  USAutoScrollView.swift
//  Usth System
//
//  Created by Serx on 2017/6/2.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit

enum CarouselViewDirec {
    case DirecNone
    case DirecLeft
    case DirecRight
}

class USAutoScrollView: UIView, UIScrollViewDelegate {
    
    
    private var _currentImgView: UIImageView?
    private var _otherImgView: UIImageView?

    private var _silenceCarouselView: UIScrollView?

    private var currentDirec: CarouselViewDirec = .DirecNone
    private var currentIndex: Int = 0
    private var nextIndex: Int = 0
    
    private var imgArr: [UIImage] = [UIImage.init(named: "head-background")!, UIImage.init(named: "deliveryDetailHeader")!]
    //MARK: - ------Life Circle------
    
    init() {

        super.init(frame: .zero)
        self.addSubview(self.silenceCarouselView!)
        self.layoutPageSubviews()
        //self.reloadImg()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - ------Methods------
    func layoutPageSubviews() {
        self.silenceCarouselView!.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    
    func reloadImg() -> Void {
        self.currentDirec = .DirecNone
        let index = self.silenceCarouselView!.contentOffset.x / self.silenceCarouselView!.bounds.size.width
        if index == 1 {
            return
        }
        self.currentIndex = self.nextIndex
        self.currentImgView!.frame = CGRect.init(x: self.silenceCarouselView!.bounds.size.width, y: 0, width: self.silenceCarouselView!.bounds.size.width, height: self.silenceCarouselView!.bounds.size.height)
        self.currentImgView!.image = self.otherImgView!.image
        self.silenceCarouselView!.contentOffset = CGPoint.init(x: self.silenceCarouselView!.bounds.size.width, y: 0)
    }
    
    func loadImg(imgView: UIImageView, index: Int) {
        let imgData = self.imgArr[index]
        imgView.image = imgData
    }
    
    //MARK: - ------Delegate View------
    
    //MARK: - ------Delegate Model------
    
    //MARK: - ------Delegate Table------
    
    //MARK: - ------Delegate Other------
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.currentDirec = self.silenceCarouselView!.contentOffset.x > self.silenceCarouselView!.bounds.size.width ? .DirecLeft : .DirecRight
        if self.currentDirec == .DirecRight {
            self.otherImgView!.frame = CGRect.init(x: 0, y: 0, width: silenceCarouselView!.bounds.size.width, height: silenceCarouselView!.bounds.size.height)
            self.nextIndex = self.currentIndex - 1
            if self.nextIndex < 0 {
                self.nextIndex = self.imgArr.count - 1
            }
        }
        else if self.currentDirec == .DirecLeft {
            self.otherImgView!.frame = CGRect.init(x: self.currentImgView!.frame.maxX, y: 0, width: self.silenceCarouselView!.bounds.size.width, height: self.silenceCarouselView!.bounds.size.height)
            self.nextIndex = (self.currentIndex + 1) % self.imgArr.count
        }
        self.loadImg(imgView: self.otherImgView!, index: self.nextIndex)
    }
    
    //MARK: - ------Event Response------
    
    //MARK: - ------Getters and Setters------
    var silenceCarouselView: UIScrollView? {
        get {
            if (_silenceCarouselView != nil) {
                return _silenceCarouselView
            }
            let scrollView = UIScrollView()
            scrollView.delegate = self
            scrollView.contentSize = CGSize.init(width: self.bounds.size.width * 3, height: self.bounds.size.height)
            scrollView.contentOffset = CGPoint.init(x: self.bounds.size.width, y: 0)
            
            scrollView.addSubview(self.currentImgView!)
            scrollView.addSubview(self.otherImgView!)
            
            //self.currentImgView!.frame = CGRect.init(x: scrollView.bounds.size.width, y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
            //self.otherImgView!.frame = CGRect.init(x: 0, y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
            
            _silenceCarouselView = scrollView
            return _silenceCarouselView
        }
    }
    
    var currentImgView: UIImageView? {
        get {
            if (_currentImgView != nil) {
                return _currentImgView
            }
            let imgView = UIImageView()
            imgView.image = imgArr[0]
            _currentImgView = imgView
            return _currentImgView
        }
    }

    var otherImgView: UIImageView? {
        get {
            if (_otherImgView != nil) {
                return _otherImgView
            }
            let imgView = UIImageView()
            imgView.image = imgArr[1]
            _otherImgView = imgView
            return _otherImgView
        }
    }
    
    //MARK: - ------Serialize and Deserialize------

}

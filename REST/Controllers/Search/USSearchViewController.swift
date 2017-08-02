//
//  USSearchViewController.swift
//  Usth System
//
//  Created by Serx on 2017/6/3.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import SnapKit

private let searchResultTableCellIdentifier: String = "searchResultTableCellIdentifier"

class USSearchViewController: UIViewController,UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate{

    
    private var _mySearchBar: UISearchBar?
    
    private var searchStr: String = ""
    
    private var _tableView: UITableView!
    
    private var subjectData: USErrorAndData!
    private var filterArr: [USSubject] = []
    
    //MARK: - ------Life Circle------
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(subjectData: USErrorAndData?) {
        self.init()
        self.subjectData = subjectData
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView!)
        self.layoutPageSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "搜索"
        self.view.backgroundColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.titleView = self.mySearchBar!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    //MARK: - ------Methods------
    func layoutPageSubviews() {
        self.tableView!.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    func filterSubjectArr() {
        self.filterArr.removeAll()
        if (self.subjectData != nil) {
            let semesterArr:[USSemester] = self.subjectData.semesterArr as! [USSemester]
            if (semesterArr.count > 0) {
                for indexS in 0..<semesterArr.count {
                    let semester: USSemester = semesterArr[indexS]
                    let subjectArr: [USSubject] = semester.subjectArr as! [USSubject]
                    if (subjectArr.count > 0) {
                        for indexC in 0..<subjectArr.count {
                            let subject = subjectArr[indexC]
                            if subject.name.range(of: self.searchStr) != nil  {
                                self.filterArr.append(subject)
                            }
                        }
                    }
                }
            }
        } else {
            
        }
        self.tableView!.reloadData()
    }
    //MARK: - ------Delegate View------
    
    //MARK: - ------Delegate Model------
    
    //MARK: - ------Delegate Table------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchResultTableCellIdentifier) as! USSubjectResultTableViewCell
        let subject = filterArr[indexPath.row]
        cell.textLabel?.text = subject.name
        cell.scoreLab?.text = String(format: "%d", subject.score.intValue)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subject = self.filterArr[indexPath.row]
        let commentVC = USCommentViewController.init(classId: subject.name, isPublic: false)
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    
    //MARK: - ------Delegate Other------
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchStr = searchBar.text!
        self.mySearchBar!.resignFirstResponder()
        self.filterSubjectArr()
    }
    //MARK: - ------Event Response------
    
    //MARK: - ------Getters and Setters------
    var mySearchBar: UISearchBar? {
        get {
            if (_mySearchBar != nil) {
                return _mySearchBar
            }
            let bar = UISearchBar.init(frame: CGRect.init(x: 0, y: 0, width: 220, height: 30.0))
            bar.delegate = self
            bar.placeholder = "请输入搜索关键字"
            _mySearchBar = bar
            return _mySearchBar
        }
    }
    
    var tableView: UITableView? {
        get {
            if (_tableView != nil) {
                return _tableView
            }
            let tableV = UITableView()
            tableV.register(USSubjectResultTableViewCell.self, forCellReuseIdentifier: searchResultTableCellIdentifier)
            tableV.delegate = self
            tableV.dataSource = self
            tableV.tableFooterView = UIView()
            
            _tableView = tableV
            return _tableView
        }
    }
    //MARK: - ------Serialize and Deserialize------


}

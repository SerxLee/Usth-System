//
//  USAnalyseView.swift
//  Usth System
//
//  Created by Serx on 2017/5/16.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit
import Charts
import SnapKit

protocol USAnalyseViewDelegate: NSObjectProtocol{
    
}

class USAnalyseView: UIView, IAxisValueFormatter {
    
    weak var delegate: USAnalyseViewDelegate?
    
    private var _scrollView: UIScrollView?
    private var _containerView: UIView?
    private var _otherView: UIView?
    
    private var _scoreLineChartView: LineChartView?
    private var _gpaLineChartView: LineChartView?
    
    var normalAverageLab: UILabel?
    var weightAverageLab: UILabel?
    var specalCreditLab: UILabel?
    var networkCreditLab: UILabel?
    var gpaLab: UILabel?
    var gpa4Lab: UILabel?
    
    private var scoreChartAxis: AxisBase!
    private var gpaChartAxis: AxisBase!
    
    private var subjectData: USErrorAndData?
    
    private var gpaData: Double?
    private var gpa4Data: Double?
    private var creditNetworkData: Double?
    private var creditCompusoryData: Double?
    private var weightAverageData: Double?
    private var normalAverageData: Double?

    private var scoreTermData: [Double]?
    private var gpaTarmData: [Double]?

    //MARK: - ------Life Circle------
    init() {
        super.init(frame: .zero)
    }
    
    convenience init(_ subjectData: USErrorAndData?) {
        self.init()
        self.subjectData = subjectData
        self.getScoreAverage(false)
        self.addSubview(self.scrollView!)
        self.layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - ------Methods------
    func layoutPageSubviews() {
        self.scrollView!.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }

    func updateLineChart(_ scoreTerm: [Double], gpaTarm: [Double]) {
        

        
    }
    
    func getScoreAverage(_ isIncludeNetwork: Bool){
        var allScore: Float = 0
        var courseNum: Float = 0.0000001
        var allScoreXCredit: Float = 0
        var creditNet: Float = 0
        var creditCompulsory: Float = 0.0000001
        var creditOptional: Float = 0.0000001
        var scoreTerm: [Double] = []
        
        var semesterArr = self.subjectData!.semesterArr
        if (semesterArr != nil) {
            semesterArr = semesterArr!
        } else {
            return
        }
        
        for t in 0..<semesterArr!.count {
            
            let semester: USSemester? = semesterArr?[t] as! USSemester
            
            var semesterAllScore: Float = 0
            var semesterCourseNum: Float = 0.0000001
            
            if (semester!.subjectArr != nil ) {
                let subjectArr = semester!.subjectArr
                for i in 0..<subjectArr!.count {
                    let subject: USSubject? = subjectArr![i] as! USSubject
                    if subject!.isCompulsory() {
                        creditCompulsory += subject!.credit.floatValue
                        semesterAllScore += subject!.score.floatValue
                        allScoreXCredit += subject!.score.floatValue * subject!.credit.floatValue
                        semesterCourseNum += 1
                    }
                    if subject!.isOptional() {
                        creditOptional += subject!.credit.floatValue
                        semesterAllScore += subject!.score.floatValue
                        allScoreXCredit += subject!.score.floatValue * subject!.credit.floatValue
                        semesterCourseNum += 1
                    }
                    if subject!.isNetwork() {
                        if isIncludeNetwork {
                            allScore += subject!.score.floatValue
                            courseNum += 1
                        }
                        creditNet += subject!.credit.floatValue
                    }
                }
            }
            courseNum += semesterCourseNum
            allScore += semesterAllScore
            scoreTerm.insert(Double(semesterAllScore / semesterCourseNum), at: 0)
        }
        
        let gpaTerm4 = self.calculateGPA(true)
        let gpaTerm = self.calculateGPA(false)
        self.normalAverageData = Double(allScore / courseNum)
        self.creditNetworkData = Double(creditNet)
        self.creditCompusoryData = Double( creditCompulsory)
        self.weightAverageData = Double(allScoreXCredit / (creditCompulsory + creditOptional))
        self.gpa4Data = self.getGPADone(gpas: gpaTerm4)
        self.gpaData = self.getGPADone(gpas: gpaTerm)
        self.gpaTarmData = gpaTerm
        self.scoreTermData = scoreTerm
    }

    func getGPADone(gpas: [Double]) -> Double {
        var num = 0
        var t1: Double = 0
        for item in gpas {
            t1 += item
            num += 1
        }
        return t1 / Double(num)
    }
    
    func calculateGPA(_ isFour: Bool) -> [Double] {
        if (self.subjectData != nil) {
            var gpaTerm: [Double] = []
            var header: Float = 0
            var footer: Float = 0.00000001
            var twoSemester: Int = 0
            var semesterArr = self.subjectData!.semesterArr
            if (semesterArr != nil) {
                semesterArr = semesterArr!
            } else {
                return []
            }
            twoSemester = semesterArr!.count % 2 == 0 ? 0: 1
            
            for t in 0..<semesterArr!.count {
                
                let semester: USSemester? = semesterArr?[t] as! USSemester
                twoSemester += 1
                if (semester?.subjectArr != nil) {
                    let subjectArr = semester?.subjectArr
                    for i in 0..<subjectArr!.count {
                        let subject: USSubject? = subjectArr![i] as! USSubject
                        
                        if (subject!.isCompulsory() || subject!.isOptional()) {
                            if isFour {
                                header += self.calculateFourScore(grade: subject!.score.floatValue) * subject!.credit.floatValue
                            } else {
                                header += subject!.score.floatValue * subject!.credit.floatValue
                            }
                            footer += subject!.credit.floatValue
                        }
                    }
                }
                if twoSemester == 2 {
                    if isFour {
                        gpaTerm.append(Double(header / footer))
                    } else {
                        gpaTerm.append(Double((header * 4.0) / (footer * 100)))
                    }
                    header = 0
                    footer = 0.00000001
                    twoSemester = 0
                }
            }
            return gpaTerm
        }
        else {
            return []
        }
    }
    
    func calculateFourScore(grade: Float) -> Float {
        var fenzhi: Float = 0
        if grade >= 90 {
            fenzhi = 4.0
        }
        else if grade >= 80 {
            fenzhi = 3.0
        }
        else if grade >= 70{
            fenzhi = 2.0
        }
        else if grade >= 60{
            fenzhi = 1.0
        }
        else {
            fenzhi = 0
        }
        return fenzhi
    }
    //MARK: - ------Delegate View------
    
    //MARK: - ------Delegate Model------
    
    //MARK: - ------Delegate Table------
    
    //MARK: - ------Delegate Other------
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if axis == self.scoreChartAxis {
            let semester:Double = value / Double(10)
            let str: String = NSString.init(format: "S%d", Int(semester)) as String
            return str
        } else if axis == self.gpaChartAxis {
            if (value.truncatingRemainder(dividingBy: 10.0) != 0) {return ""}
            let year: Double = value / Double(10)
            let str: String = NSString.init(format: "Yr%d", Int(year)) as String
            return str
        }
        return ""
    }
    
    //MARK: - ------Event Response------
    
    //MARK: - ------Getters and Setters------
    var scrollView: UIScrollView? {
        get {
            if (_scrollView != nil) {
                return _scrollView
            }
            let tempScrollView = UIScrollView()
            tempScrollView.showsVerticalScrollIndicator = false
            
            tempScrollView.addSubview(self.containerView!)
            self.containerView!.snp.makeConstraints { (make) in
                make.edges.equalTo(tempScrollView)
                make.width.equalTo(SCREEN_WIDTH)
            }
            
            tempScrollView.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.containerView!.snp.bottom)
            }
            
            _scrollView = tempScrollView
            return _scrollView
        }
    }
    var containerView: UIView? {
        get {
            if (_containerView != nil) {
                return _containerView
            }
            let tempView = UIView()
            
            tempView.addSubview(self.otherView!)
            tempView.addSubview(self.scoreLineChartView!)
            tempView.addSubview(self.gpaLineChartView!)
            
            self.otherView!.snp.makeConstraints { (make) in
                make.top.left.right.equalTo(tempView)
                
            }
            
            self.scoreLineChartView!.snp.makeConstraints { (make) in
                make.top.equalTo(self.otherView!.snp.bottom)
                make.left.equalTo(tempView).offset(15.0)
                make.right.equalTo(tempView).offset(-15.0)
                make.height.equalTo(SCREEN_HEIGHT / 4.0)
            }
            self.gpaLineChartView!.snp.makeConstraints { (make) in
                make.top.equalTo(self.scoreLineChartView!.snp.bottom).offset(30.0)
                make.left.equalTo(tempView).offset(15.0)
                make.right.equalTo(tempView).offset(-15.0)
                make.height.equalTo(SCREEN_HEIGHT / 4.0)
            }
            
            tempView.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.gpaLineChartView!.snp.bottom).offset(40.0)
            }
            
            _containerView = tempView
            return _containerView
        }
    }
    
    var otherView: UIView? {
        get {
            if (_otherView != nil) {
                return _otherView
            }
            let tempView = UIView()
            tempView.backgroundColor = UIColor.white
            
            let topLeftLab = self.createBaseLab()
            topLeftLab.text = "普通均分"
            let topCenterLab = self.createBaseLab()
            topCenterLab.text = "必修学分"
            let topRightLab = self.createBaseLab()
            topRightLab.text = "任修学分"
            let bottomleftLab = self.createBaseLab()
            bottomleftLab.text = "加权均分"
            let bottomCenterLab = self.createBaseLab()
            bottomCenterLab.text = "4‘GPA"
            let bottomRightLab = self.createBaseLab()
            bottomRightLab.text = "标准GPA"
            tempView.addSubview(topLeftLab)
            tempView.addSubview(topCenterLab)
            tempView.addSubview(topRightLab)
            tempView.addSubview(bottomleftLab)
            tempView.addSubview(bottomCenterLab)
            tempView.addSubview(bottomRightLab)
            self.normalAverageLab = self.createBaseLab()
            self.normalAverageLab?.text = String(format: "%.2f", self.normalAverageData!)
            self.weightAverageLab = self.createBaseLab()
            self.weightAverageLab?.text = String(format: "%.2f", self.weightAverageData!)
            self.specalCreditLab = self.createBaseLab()
            self.specalCreditLab?.text = String(format: "%.2f", self.creditCompusoryData!)
            self.networkCreditLab = self.createBaseLab()
            self.networkCreditLab?.text = String(format: "%.2f", self.creditNetworkData!)
            self.gpaLab = self.createBaseLab()
            self.gpaLab?.text = String(format: "%.2f", self.gpaData!)
            self.gpa4Lab = self.createBaseLab()
            self.gpa4Lab?.text = String(format: "%.2f", self.gpa4Data!)
            tempView.addSubview(self.normalAverageLab!)
            tempView.addSubview(self.weightAverageLab!)
            tempView.addSubview(self.specalCreditLab!)
            tempView.addSubview(self.networkCreditLab!)
            tempView.addSubview(self.gpaLab!)
            tempView.addSubview(self.gpa4Lab!)
            
            topLeftLab.snp.makeConstraints { (make) in
                make.top.equalTo(tempView).offset(40.0)
                make.left.equalTo(tempView).offset(20.0)
                make.width.equalTo(60.0)
                make.height.equalTo(21.0)
            }
            topCenterLab.snp.makeConstraints { (make) in
                make.top.equalTo(topLeftLab)
                make.centerX.equalTo(tempView)
                make.width.equalTo(60.0)
                make.height.equalTo(21.0)
            }
            topRightLab.snp.makeConstraints { (make) in
                make.top.equalTo(topLeftLab)
                make.right.equalTo(tempView).offset(-20.0)
                make.width.equalTo(60.0)
                make.height.equalTo(21.0)
            }
            
            self.normalAverageLab!.snp.makeConstraints { (make) in
                make.top.equalTo(topLeftLab.snp.bottom).offset(20.0)
                make.centerX.equalTo(topLeftLab.snp.centerX)
                make.width.equalTo(60.0)
                make.height.equalTo(21.0)
            }
            self.specalCreditLab!.snp.makeConstraints { (make) in
                make.top.equalTo(self.normalAverageLab!)
                make.centerX.equalTo(topCenterLab.snp.centerX)
                make.width.equalTo(60.0)
                make.height.equalTo(21.0)
            }
            self.networkCreditLab!.snp.makeConstraints { (make) in
                make.top.equalTo(self.normalAverageLab!)
                make.centerX.equalTo(topRightLab.snp.centerX)
                make.width.equalTo(60.0)
                make.height.equalTo(21.0)
            }
            
            bottomleftLab.snp.makeConstraints { (make) in
                make.top.equalTo(self.normalAverageLab!.snp.bottom).offset(50.0)
                make.centerX.equalTo(topLeftLab.snp.centerX)
                make.width.equalTo(60.0)
                make.height.equalTo(21.0)
            }
            bottomCenterLab.snp.makeConstraints { (make) in
                make.top.equalTo(bottomleftLab)
                make.centerX.equalTo(topCenterLab.snp.centerX)
                make.width.equalTo(60.0)
                make.height.equalTo(21.0)
            }
            bottomRightLab.snp.makeConstraints { (make) in
                make.top.equalTo(bottomleftLab)
                make.centerX.equalTo(topRightLab.snp.centerX)
                make.width.equalTo(60.0)
                make.height.equalTo(21.0)
            }
            
            self.weightAverageLab!.snp.makeConstraints { (make) in
                make.top.equalTo(bottomleftLab.snp.bottom).offset(20.0)
                make.centerX.equalTo(topLeftLab.snp.centerX)
                make.width.equalTo(60.0)
                make.height.equalTo(21.0)
            }
            self.gpa4Lab!.snp.makeConstraints { (make) in
                make.top.equalTo(bottomCenterLab.snp.bottom).offset(20.0)
                make.centerX.equalTo(topCenterLab.snp.centerX)
                make.width.equalTo(60.0)
                make.height.equalTo(21.0)
            }
            self.gpaLab!.snp.makeConstraints { (make) in
                make.top.equalTo(bottomRightLab.snp.bottom).offset(20.0)
                make.centerX.equalTo(topRightLab.snp.centerX)
                make.width.equalTo(60.0)
                make.height.equalTo(21.0)
            }
            
            
            //add line
            let horizontalCenterLine: UIView = UIView.init()
            tempView.addSubview(horizontalCenterLine)
            horizontalCenterLine.backgroundColor = UIColor.lineGray()
            horizontalCenterLine.snp.makeConstraints { (make) in
                make.left.equalTo(tempView).offset(20.0)
                make.right.equalTo(tempView).offset(-20.0)
                make.height.equalTo(0.5)
                make.top.equalTo(self.normalAverageLab!.snp.bottom).offset(50.0 / 2.0)
            }
            let spaceNum = (SCREEN_WIDTH - 3.0 * 60.0 - 2.0 * 20.0) / 4.0
            let verticalLeftLine: UIView = UIView.init()
            tempView.addSubview(verticalLeftLine)
            verticalLeftLine.backgroundColor = UIColor.lineGray()
            verticalLeftLine.snp.makeConstraints { (make) in
                make.left.equalTo(topLeftLab.snp.right).offset(spaceNum)
                make.width.equalTo(0.5)
                make.top.equalTo(tempView).offset(20.0)
                make.bottom.equalTo(self.weightAverageLab!.snp.bottom)
            }
            
            let verticalRightLine: UIView = UIView.init()
            tempView.addSubview(verticalRightLine)
            verticalRightLine.backgroundColor = UIColor.lineGray()
            verticalRightLine.snp.makeConstraints { (make) in
                make.left.equalTo(topCenterLab.snp.right).offset(spaceNum)
                make.width.equalTo(0.5)
                make.top.equalTo(verticalLeftLine)
                make.bottom.equalTo(verticalLeftLine)
            }
            
            tempView.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.weightAverageLab!.snp.bottom).offset(50.0)
            }
            
            _otherView = tempView
            return _otherView
        }
    }

    
    var scoreLineChartView: LineChartView? {
        get {
            if (_scoreLineChartView != nil) {
                return _scoreLineChartView
            }
            let chartView = LineChartView()
            
            chartView.backgroundColor = UIColor.clear
            chartView.chartDescription?.text = "每学期(S)平均分表"
            chartView.rightAxis.enabled = false
            chartView.xAxis.drawGridLinesEnabled = false
            chartView.legend.enabled = false
            chartView.scaleXEnabled = false
            chartView.scaleYEnabled = false
            
            let left = chartView.getAxis(YAxis.AxisDependency.left)
            chartView.animate(xAxisDuration: 1.5, easingOption: .easeInOutBack)
            left.axisMinimum = 0.0
            left.axisMaximum = 100.0
            
            var scoreDataEntries: [ChartDataEntry] = []
            for i in 0..<self.scoreTermData!.count {
                let chartData = ChartDataEntry.init(x: Double((i + 1) * 10), y: self.scoreTermData![i])
                scoreDataEntries.append(chartData)
            }
            
            let scoreLineChartDataSet = LineChartDataSet.init(values: scoreDataEntries, label: "Units Sold")
            scoreLineChartDataSet.circleColors = [UIColor.sexBlue()]
            let scoreLineChartData = LineChartData.init(dataSets: [scoreLineChartDataSet] as [IChartDataSet])
            
            chartView.data = scoreLineChartData
            
            self.scoreChartAxis = chartView.xAxis
            self.scoreChartAxis.valueFormatter = self
            
            _scoreLineChartView = chartView
            return _scoreLineChartView
        }
    }
    var gpaLineChartView: LineChartView? {
        get {
            if (_gpaLineChartView != nil) {
                return _gpaLineChartView
            }
            let chartView = LineChartView()
            chartView.backgroundColor = UIColor.clear
            chartView.chartDescription?.text = "每学年(Yr)平均学分绩点表"
            chartView.rightAxis.enabled = false
            chartView.xAxis.drawGridLinesEnabled = false
            chartView.legend.enabled = false
            chartView.scaleXEnabled = false
            chartView.scaleYEnabled = false
            
            
            let left = chartView.getAxis(YAxis.AxisDependency.left)
            chartView.animate(xAxisDuration: 1.5, easingOption: .easeInOutBack)
            left.axisMinimum = 0.0
            left.axisMaximum = 5.0
            
            var gpaDataEntries: [ChartDataEntry] = []
            for i in 0..<self.gpaTarmData!.count {
                let chartData = ChartDataEntry.init(x: Double((i + 1) * 10), y: self.gpaTarmData![i])
                gpaDataEntries.append(chartData)
            }
            let lineChartDataSet = LineChartDataSet.init(values: gpaDataEntries, label: "gpa")
            lineChartDataSet.circleColors = [UIColor.sexBlue()]
            let lineChartData = LineChartData.init(dataSets: [lineChartDataSet] as [IChartDataSet])
            
            chartView.data = lineChartData
            
            self.gpaChartAxis = chartView.xAxis
            self.gpaChartAxis.valueFormatter = self
            
            _gpaLineChartView = chartView
            return _gpaLineChartView
        }
    }
    
    func createBaseLab() -> UILabel {
        let lab = UILabel.init()
        lab.font = UIFont.systemFont(ofSize: 14.0)
        lab.textAlignment = .center
        return lab
    }
    
    
    //MARK: - ------Serialize and Deserialize------
 

}

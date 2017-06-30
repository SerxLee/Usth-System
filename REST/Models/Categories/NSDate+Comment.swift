//
//  NSDate+Comment.swift
//  EducationSystem
//
//  Created by Serx on 16/5/27.
//  Copyright © 2016年 Serx.Lee. All rights reserved.
//

import Foundation

/** Comment Extends NSDate

*/
extension NSDate{
    class func handleDate(date: NSDate) -> NSDate?{
        let dateF = DateFormatter()
        dateF.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        let date2 = dateF.string(from: date as Date)
        let date = dateF.date(from: date2)
        return date as NSDate?
    }
    func fullDescription() -> String {
        let calendar = NSCalendar.current
        
        if calendar.isDateInToday(self as Date) {
            let delta = Int(NSDate().timeIntervalSince(self as Date))
            if delta < 60 {
                return "刚刚"
            } else if delta < 60 * 60 {
                return "\(delta / 60)分钟前"
            }
            return "\(delta / 3600)小时前"
        }else {
            var dateformatString = ""
            if calendar.isDateInYesterday(self as Date) {
                dateformatString = "昨天 HH:mm"
            } else {
                /*
                //let result = calendar.components(.year, fromDate: self, toDate: NSDate(), options: [])
                let result = calendar.dateComponents(Set<Calendar.Component>, from: <#T##Date#>, to: <#T##Date#>)
                if result.year == 0 {
                    dateformatString = "MM-dd HH:mm"
                } else {
                    dateformatString = "yyyy-MM-dd HH:mm"
                }
                 */
                dateformatString = "MM-dd HH:mm"

            }
            let df = DateFormatter()
            df.dateFormat = dateformatString
            return df.string(from: self as Date)
        }
    }
}

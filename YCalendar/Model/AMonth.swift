//
//  AMonth.swift
//  YCalendar
//
//  Created by 尤坤 on 2022/7/26.
//

import UIKit

class DayContainer: NSObject {
    var days = [ADay]()
}

class AMonth: DayContainer {
    let month: Month
    let year: Year
    let offset: Int
    
    init(byAdding monthOffset: Int) {
        self.offset = monthOffset
        
        let currentDateComponents = Calendar.current.dateComponents([.month, .year], from: Date())
        let currentMonth = currentDateComponents.month ?? 1
        let currenYear = currentDateComponents.year ?? 0
        
        var newMonth = (currentMonth + monthOffset) % 12
        if newMonth <= 0 {
            newMonth += 12
        }
        var newYear = currenYear
        if monthOffset >= 0 {
            newYear = currenYear + (currentMonth + monthOffset + 11) / 12 - 1
        } else {
            newYear = currenYear + (currentMonth + monthOffset - 12) / 12
        }
        
        month = Month(rawValue: newMonth) ?? .jan
        year = newYear
        
        super.init()
        
        setup()
    }
    
    func getDaysWithPlaceholder() -> [ADay] {
        guard let weekday = days.first?.weekday else { return [] }
        
        var result = Array(days)
        for _ in 0..<(weekday.rawValue - 1) {
            result.insert(ADay(date: nil), at: 0)
        }
        
        return result
    }
    
    private func setup() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_CN")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "y/M/d,HH:mm:ss"
        let newDate = dateFormatter.date(from: "\(year)/\(month.rawValue)/1,00:00:00")
        
        let daysInMonth = getDays(in: month, of: year)
        for index in 0..<daysInMonth {
            days.append(ADay(date: Date(timeInterval: ((TimeInterval)(index)) * 24 * 60 * 60, since: newDate ?? Date())))
        }
    }
    
    private func getDays(in month: Month, of year: Year) -> Int {
        switch month {
        case .jan, .mar, .may, .jul, .aug, .oct, .dec:
            return 31
        case .apr, .jun, .sep, .nov:
            return 30
        case .feb:
            if year % 4 == 0 {
                if year % 100 == 0  {
                    if year % 400 == 0 {
                        return 29
                    } else {
                        return 28
                    }
                } else {
                    return 29
                }
            } else {
                return 28
            }
        }
    }
    
    static func <(_ lhs: AMonth, _ rhs:AMonth) -> Bool {
        return lhs.year < rhs.year || (lhs.month.rawValue < rhs.month.rawValue && lhs.year == rhs.year)
    }
    
    static func -(_ lhs: AMonth, _ rhs:AMonth) -> Int {
        return 12 * (lhs.year - rhs.year) + lhs.month.rawValue - rhs.month.rawValue
    }
}

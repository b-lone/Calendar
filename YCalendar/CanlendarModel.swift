//
//  CalendarModel.swift
//  YCalendar
//
//  Created by Archie on 2022/7/16.
//

import Foundation

typealias Day = Int

enum Weekday: Int {
    case sun = 1
    case mon = 2
    case tue = 3
    case wed = 4
    case thur = 5
    case fri = 6
    case sat = 7
    
    var abbreviation: String {
        switch self {
        case .sun:
            return "Sun"
        case .mon:
            return "Mon"
        case .tue:
            return "Tue"
        case .wed:
            return "Wed"
        case .thur:
            return "Thur"
        case .fri:
            return "Fri"
        case .sat:
            return "Sat"
        }
    }
}

enum Month: Int {
    case jan = 1
    case feb = 2
    case mar = 3
    case apr = 4
    case may = 5
    case jun = 6
    case jul = 7
    case aug = 8
    case sep = 9
    case oct = 10
    case nov = 11
    case dec = 12
    
    var abbreviation: String {
        switch self {
        case .jan:
            return "Jan"
        case .feb:
            return "Feb"
        case .mar:
            return "Mar"
        case .apr:
            return "Apr"
        case .may:
            return "May"
        case .jun:
            return "Jun"
        case .jul:
            return "Jul"
        case .aug:
            return "Aug"
        case .sep:
            return "Sep"
        case .oct:
            return "Oct"
        case .nov:
            return "Mov"
        case .dec:
            return "Dec"
        }
    }
}

typealias Year = Int

class DayModel: NSObject {
    class var placeholder: DayModel {
        return DayModel()
    }
    var isPlaceholder: Bool
    
    private var date: Date?
    var day: Day
    var weekday: Weekday
    var month: Month
    var year: Year
    
    private override init() {
        isPlaceholder = true
        
        day = 0
        weekday = .sun
        month = .jan
        year = 0
        
        super.init()
    }
    
    init(date: Date) {
        isPlaceholder = false
        
        self.date = date
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([
            .era,
            .year,
            .yearForWeekOfYear,
            .quarter,
            .month,
            .weekOfYear,
            .weekOfMonth,
            .weekday,
            .weekdayOrdinal,
            .day,
            .calendar,
            .timeZone
        ], from: date)
        
        day = dateComponents.day ?? 0
        weekday = Weekday(rawValue: dateComponents.weekday ?? 0) ?? .sun
        month = Month(rawValue: dateComponents.month ?? 0) ?? .jan
        year = dateComponents.year ?? 0
        
        super.init()
    }
    
    override var description: String {
        return "{day:\(day), weekday:\(weekday), month:\(month), year:\(year)}"
    }
}

class DayContainer: NSObject {
    var days = [DayModel]()
}

class AWeek: DayContainer {
    init(byAdding weekOffset: Int) {
        super.init()
        
        let date = Date(timeInterval: ((TimeInterval)(weekOffset)) * 7 * 24 * 60 * 60, since: Date.now)
        let weekday = Calendar.current.dateComponents([.weekday], from: date).weekday ?? 1
        for i in 0...6 {
            let aDate = Date(timeInterval: ((TimeInterval)(i + 1 - weekday)) * 24 * 60 * 60, since: date)
            days.append(DayModel(date: aDate))
        }
    }
}

class AMonth: DayContainer {
    let month: Month
    let year: Year
    
    init(byAdding monthOffset: Int) {
        let currentDateComponents = Calendar.current.dateComponents([.month, .year], from: Date.now)
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_CN")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "y/M/d,HH:mm:ss"
        let newDate = dateFormatter.date(from: "\(newYear)/\(newMonth)/1,00:00:00")
        
        let daysInMonth = getDays(in: Month(rawValue: newMonth) ?? .jan, of: newYear)
        for index in 0..<daysInMonth {
            days.append(DayModel(date: Date(timeInterval: ((TimeInterval)(index)) * 24 * 60 * 60, since: newDate ?? Date.now)))
        }
    }
    
    func getDays(in month: Month, of year: Year) -> Int {
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
    
    override var description: String {
        return "{first day:\(days.first!), last day:\(days.last!), count:\(days.count)}"
    }
}

class AYear: DayContainer {
}

class MonthDataSource: NSObject {
    let days: [DayModel]
    let month: Month
    let year: Year
    let offset: Int
    
    init(byAdding monthOffset: Int) {
        offset = monthOffset
        
        let aMonth = AMonth(byAdding: monthOffset)
        var days = aMonth.days
        for _ in 0..<(days[0].weekday.rawValue - 1) {
            days.insert(DayModel.placeholder, at: 0)
        }
        
        self.days = days
        month = aMonth.month
        year = aMonth.year
        
        super.init()
    }
    
    static func <(_ lhs: MonthDataSource, _ rhs:MonthDataSource) -> Bool {
        return lhs.year < rhs.year || (lhs.month.rawValue < rhs.month.rawValue && lhs.year == rhs.year)
    }
    
    static func -(_ lhs: MonthDataSource, _ rhs:MonthDataSource) -> Int {
        return 12 * (lhs.year - rhs.year) + lhs.month.rawValue - rhs.month.rawValue
    }
}

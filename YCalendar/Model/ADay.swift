//
//  ADay.swift
//  YCalendar
//
//  Created by 尤坤 on 2022/7/26.
//

import Foundation

class ADay: NSObject {
    private var date: Date?
    private var dateComponents: DateComponents?
    
    var day: Day? { dateComponents?.day }
    var weekday: Weekday? { Weekday(rawValue: dateComponents?.weekday ?? -1) }
    var month: Month? { Month(rawValue: dateComponents?.month ?? -1) }
    var year: Year? { dateComponents?.year }
    
    var isValid: Bool { date != nil }
    var isToday: Bool {
        let currentDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        return dateComponents?.day == currentDateComponents.day && dateComponents?.month == currentDateComponents.month && dateComponents?.year == currentDateComponents.year
    }
    
    init(date: Date?) {
        super.init()
        
        update(date: date)
    }
    
    func update(date: Date?) {
        self.date = date
        guard let date = date else {
            return dateComponents = nil
        }

        self.dateComponents = Calendar.current.dateComponents([
            .year,
            .month,
            .weekday,
            .day
        ], from: date)
    }
}

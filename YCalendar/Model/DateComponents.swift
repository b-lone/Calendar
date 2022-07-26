//
//  DateComponents.swift
//  YCalendar
//
//  Created by 尤坤 on 2022/7/26.
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
        case .sun: return "Sun"
        case .mon: return "Mon"
        case .tue: return "Tue"
        case .wed: return "Wed"
        case .thur: return "Thur"
        case .fri: return "Fri"
        case .sat: return "Sat"
        }
    }
    
    var isWeekend: Bool {
        switch self {
        case .mon, .tue, .wed, .thur,. fri: return false
        case .sun, .sat: return true
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
        case .jan: return "Jan"
        case .feb: return "Feb"
        case .mar: return "Mar"
        case .apr: return "Apr"
        case .may: return "May"
        case .jun: return "Jun"
        case .jul: return "Jul"
        case .aug: return "Aug"
        case .sep: return "Sep"
        case .oct: return "Oct"
        case .nov: return "Mov"
        case .dec: return "Dec"
        }
    }
}

typealias Year = Int

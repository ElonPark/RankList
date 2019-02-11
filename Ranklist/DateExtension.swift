//
//  DateExtension.swift
//  Ranklist
//
//  Created by Elon on 09/02/2019.
//  Copyright © 2019 Nebula_MAC. All rights reserved.
//

import Foundation

extension Date {
    
    static func today() -> Date {
        return Date()
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date? {
        return get(.next, weekday, considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date? {
        return get(.previous, weekday, considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection, _ weekDay: Weekday, considerToday consider: Bool = false) -> Date? {
        let dayName = weekDay.rawValue
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        guard let index = weekdaysName.index(of: dayName) else { return nil }
        let searchWeekdayIndex = index + 1
        let calendar = Calendar(identifier: .gregorian)
        
        guard consider && calendar.component(.weekday, from: self) != searchWeekdayIndex else { return self }
        
        var nextDateComponent = DateComponents()
        nextDateComponent.weekday = searchWeekdayIndex
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date
    }
    
}

// MARK: Helper methods
extension Date {
    
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case next
        case previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .next:
                return .forward
            case .previous:
                return .backward
            }
        }
    }
}

//
//  Date.swift
//  ParseStarterProject-Swift
//
//  Created by Steven on 1/13/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation

class Date {
    private var day: Int
    private var month: Int
    private var year: Int
    private var hour: Int
    private var minute: Int

    private var currentYear = 1900
    private var currentMonth = 1
    private var currentDay = 1
    private var currentHour = 0
    private var currentMinute = 0

    init () {
        day = 1
        month = 1
        year = 1900
        hour = 0
        minute = 0
    }

    init (hour: Int, minute: Int) {
        self.day = 1
        self.month = 1
        self.year = 1900
        self.hour = hour
        self.minute = minute
        setCurrentDate()
    }

    init (day: Int, month: Int, year: Int) {
        self.day = day
        self.month = month
        self.year = year
        self.hour = 0
        self.minute = 0
        setCurrentDate()
    }

    init (day: Int, month: Int, year: Int, hour: Int, minute: Int) {
        self.day = day
        self.month = month
        self.year = year
        self.hour = hour
        self.minute = minute
        setCurrentDate()
    }

    func dayAsString() -> String {
        if (day < 10) {
            return "0" + String(day)
        }
        return String(day)
    }

    func monthAsString() -> String {
        if (month < 10) {
            return "0" + String(month)
        }
        return String(month)
    }

    func yearAsString() -> String {
        return String(year)
    }

    func hourAsString() -> String {
        if (hour < 10) {
            return "0" + String(hour)
        }
        return String(hour)
    }

    func minuteAsString() -> String {
        if (minute < 10) {
            return "0" + String(minute)
        }
        return String(minute)
    }

    func fullDateAmerican() -> String {
        return monthAsString() + "/" + dayAsString() + "/" + yearAsString()
    }

    func fullDateEuropean() -> String {
        return dayAsString() + "/" + monthAsString() + "/" + yearAsString()
    }

    func fullTime() -> String {
        return hourAsString() + ":" + minuteAsString()
    }

    func age() -> Int {
        var age = currentYear - year
        if (month > currentMonth) {
            age = age - 1
        }
        if (month == currentMonth && day > currentDay) {
            age = age - 1
        }
        return age
    }

    func setCurrentDate() {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        currentYear = calendar.components(.Year, fromDate: date).year
        currentMonth = calendar.components(.Month, fromDate: date).month
        currentDay = calendar.components(.Day, fromDate: date).day
        currentHour = calendar.components(.Hour, fromDate: date).hour
        currentMinute = calendar.components(.Minute, fromDate: date).minute
    }

}

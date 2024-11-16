//
//  BookingSchedule.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/15/24.
//

import Foundation

struct BookingSchedule: Equatable, Identifiable {
    var schedule_id: Int
    var booking_id: Int
    var startDate: Date
    var endDate: Date
    
    var id: Int {
        return schedule_id
    }
    
    init(schedule_id: Int, booking_id: Int, startDate: Date, endDate: Date) {
        self.schedule_id = schedule_id
        self.booking_id = booking_id
        self.startDate = startDate
        self.endDate = endDate
    }
}


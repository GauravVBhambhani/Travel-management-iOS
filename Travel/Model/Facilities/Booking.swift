//
//  Booking.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import Foundation

struct Booking: Equatable, Identifiable {
    var booking_id: Int
    var item_id: Int
    var user_id: Int
    
    var booking_date: Date
    var total_cost: Float
    var payment_status: String
    
    var id: Int {
        return booking_id
    }
    
    init(booking_id: Int, item_id: Int, user_id: Int, booking_date: Date, total_cost: Float, payment_status: String) {
        self.booking_id = booking_id
        self.item_id = item_id
        self.user_id = user_id
        self.booking_date = booking_date
        self.total_cost = total_cost
        self.payment_status = payment_status
    }
}

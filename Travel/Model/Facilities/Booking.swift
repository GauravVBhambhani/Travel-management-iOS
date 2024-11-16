//
//  Booking.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import Foundation

struct Booking: Equatable, Identifiable {
    var booking_id: Int
    var user_id: Int
    
    var booking_date: String
    var total_cost: Float
    var payment_status: String
    
    var accommodation_id: Int?
    var activity_id: Int?
    var schedule_id: Int?
    
    var itinerary_id: Int?
    
    var id: Int {
        return booking_id
    }
    
    init(booking_id: Int, user_id: Int, booking_date: String, total_cost: Float, payment_status: String,
         accommodation_id: Int?, activity_id: Int?, schedule_id: Int?, itinerary_id: Int?) {
        self.booking_id = booking_id
        self.user_id = user_id
        self.booking_date = booking_date
        self.total_cost = total_cost
        self.payment_status = payment_status
        self.accommodation_id = accommodation_id
        self.activity_id = activity_id
        self.schedule_id = schedule_id
        self.itinerary_id = itinerary_id
    }
}

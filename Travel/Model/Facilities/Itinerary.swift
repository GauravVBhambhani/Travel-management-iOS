//
//  Itinerary.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import Foundation

struct Itinerary: Equatable, Identifiable {
    var itinerary_id: Int
    var user_id: Int
    var start_date: Date
    var end_date: Date
    var destination: String
    var total_cost: String
    
    var id: Int {
        return itinerary_id
    }
    
    init(itinerary_id: Int, user_id: Int, start_date: Date, end_date: Date, destination: String, total_cost: String) {
        self.itinerary_id = itinerary_id
        self.user_id = user_id
        self.start_date = start_date
        self.end_date = end_date
        self.destination = destination
        self.total_cost = total_cost
    }
}

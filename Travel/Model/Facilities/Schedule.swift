//
//  Schedule.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/15/24.
//

import Foundation

struct Schedule: Equatable, Identifiable {
    var schedule_id: Int
    var assetID: Int
    var departureTime: String
    var arrivalTime: String
    var price: Float
    
    var id: Int {
        return schedule_id
    }
    
    init(schedule_id: Int, assetID: Int, departureTime: String, arrivalTime: String, price: Float) {
        self.schedule_id = schedule_id
        self.assetID = assetID
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
        self.price = price
    }
}

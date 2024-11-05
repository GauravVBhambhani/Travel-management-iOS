//
//  Activity.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import Foundation

struct Activity: Equatable, Identifiable {
    var activity_id: Int
    var destination_id: Int
    var name: String
    var description: String
    var location: String
    var duration: String
    var price: String
    
    var id: Int {
        return activity_id
    }
    
    init(activity_id: Int, destination_id: Int, name: String, description: String, location: String, duration: String, price: String) {
        self.activity_id = activity_id
        self.destination_id = destination_id
        self.name = name
        self.description = description
        self.location = location
        self.duration = duration
        self.price = price
    }
}

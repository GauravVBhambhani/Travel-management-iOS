//
//  Accomodation.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import Foundation

struct Accommodation: Equatable, Identifiable, Hashable {
    var accommodation_id: Int
    var destination_id: Int
    var name: String
    var street: String
    var city: String
    var state: String
    var zipcode: Int
    var type: String
    var price_per_night: Float
    var availability_status: String
    var rating: Int
    
    var id: Int {
        return accommodation_id
    }
    
    init(accommodation_id: Int, destination_id: Int, name: String, street: String, city: String, state: String, zipcode: Int, type: String, price_per_night: Float, availability_status: String, rating: Int) {
        self.accommodation_id = accommodation_id
        self.destination_id = destination_id
        self.name = name
        self.street = street
        self.city = city
        self.state = state
        self.zipcode = zipcode
        self.type = type
        self.price_per_night = price_per_night
        self.availability_status = availability_status
        self.rating = rating
    }
}

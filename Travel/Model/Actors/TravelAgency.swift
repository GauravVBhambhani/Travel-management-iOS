//
//  TravelAgency.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import Foundation

struct TravelAgency: Equatable, Identifiable, Hashable {
    
    var agency_id: Int
    var name: String
    var location: String
    var contact_info: String
    var rating: Int
    
    var id: Int {
        return agency_id
    }
    
    init(agency_id: Int, name: String, location: String, contact_info: String, rating: Int) {
        self.agency_id = agency_id
        self.name = name
        self.location = location
        self.contact_info = contact_info
        self.rating = rating
    }
}

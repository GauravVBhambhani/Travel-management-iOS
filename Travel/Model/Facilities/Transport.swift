//
//  Transport.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import Foundation

struct Transport: Equatable, Identifiable {
    var transport_id: Int
    var type: String
    var company_name: String
    var departure_time: String
    var arrival_time: String
    var price: Float
    
    var id: Int {
        return transport_id
    }
    
    init(transport_id: Int, type: String, company_name: String, departure_time: String, arrival_time: String, price: Float) {
        self.transport_id = transport_id
        self.type = type
        self.company_name = company_name
        self.departure_time = departure_time
        self.arrival_time = arrival_time
        self.price = price
    }
}

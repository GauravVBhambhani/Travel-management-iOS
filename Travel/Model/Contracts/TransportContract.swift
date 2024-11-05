//
//  TransportContract.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import Foundation

struct TransportContract: Equatable {
    var agency_id: Int
    var transport_id: Int
    var contractStartDate: Date
    var contractEndDate: Date
    
    init(agency_id: Int, transport_id: Int, contractStartDate: Date, contractEndDate: Date) {
        self.agency_id = agency_id
        self.transport_id = transport_id
        self.contractStartDate = contractStartDate
        self.contractEndDate = contractEndDate
    }
}

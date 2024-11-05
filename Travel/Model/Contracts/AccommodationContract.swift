//
//  AccomodationContract.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import Foundation

struct AccommodationContract: Equatable {
    var agency_id: Int
    var accommodation_id: Int
    var contractStartDate: Date
    var contractEndDate: Date
    
    init(agency_id: Int, accommodation_id: Int, contractStartDate: Date, contractEndDate: Date) {
        self.agency_id = agency_id
        self.accommodation_id = accommodation_id
        self.contractStartDate = contractStartDate
        self.contractEndDate = contractEndDate
    }
}

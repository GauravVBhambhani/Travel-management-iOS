//
//  AssetContract.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/15/24.
//

import Foundation

struct AssetContract: Equatable, Identifiable {
    var agency_id: Int
    var asset_id: Int
    var contractStartDate: Date
    var contractEndDate: Date
    
    var id: Int {
        return agency_id
    }
    
    init(agency_id: Int, asset_id: Int, contractStartDate: Date, contractEndDate: Date) {
        self.agency_id = agency_id
        self.asset_id = asset_id
        self.contractStartDate = contractStartDate
        self.contractEndDate = contractEndDate
    }
}

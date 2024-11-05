//
//  GuideContract.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import Foundation

struct GuideContract: Equatable {
    var activity_id: Int
    var guide_id: Int
    var ContractStartDate: Date
    var ContractEndDate: Date
    
    init(activity_id: Int, guide_id: Int, ContractStartDate: Date, ContractEndDate: Date) {
        self.activity_id = activity_id
        self.guide_id = guide_id
        self.ContractStartDate = ContractStartDate
        self.ContractEndDate = ContractEndDate
    }
}

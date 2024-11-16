//
//  CustomerSupport.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import Foundation

struct CustomerSupport: Identifiable, Equatable {
    var support_id: Int
    var user_id: Int
    var issueDescription: String
    var resolutionStatus: String
    var resolutionDate: Date?
    
    var id: Int {
        return support_id
    }
    
    init(support_id: Int, user_id: Int, issueDescription: String, resolutionStatus: String, resolutionDate: Date?) {
        self.support_id = support_id
        self.user_id = user_id
        self.issueDescription = issueDescription
        self.resolutionStatus = resolutionStatus
        self.resolutionDate = resolutionDate
    }
}

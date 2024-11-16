//
//  Asset.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/15/24.
//

import Foundation

struct Asset: Equatable, Identifiable, Hashable {
    var asset_id: Int
    var type: String
    var companyName: String?
    var description: String?
    var value: Float
    
    var id: Int {
        return asset_id
    }
    
    init(asset_id: Int, type: String, companyName: String?, description: String?, value: Float) {
        self.asset_id = asset_id
        self.type = type
        self.companyName = companyName
        self.description = description
        self.value = value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(asset_id)
    }
}

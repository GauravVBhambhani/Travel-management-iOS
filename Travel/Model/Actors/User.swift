//
//  User.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import Foundation

struct User: Identifiable, Equatable {
    let user_id: Int
    
    var firstName: String
    var lastName: String
    var phone: String
    
    var email: String
    var password: String
    
    var street: String
    var city: String
    var state: String
    var pincode: Int
    
    var id: Int {
        return user_id
    }
    
    init(user_id: Int ,firstName: String, lastName: String, phone: String, email: String, password: String, street: String, city: String, state: String, pincode: Int) {
        self.user_id = user_id
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.email = email
        self.password = password
        self.street = street
        self.city = city
        self.state = state
        self.pincode = pincode
    }
}

//
//  Payment.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import Foundation

struct Payment: Equatable, Identifiable {
    var payment_id: Int
    var booking_id: Int
    var payment_method: String
    var payment_amount: Float
    var payment_status: String
    var transaction_date: Date
    
    var id: Int {
        return payment_id
    }
    
    init(payment_id: Int, booking_id: Int, payment_method: String, payment_amount: Float, payment_status: String, transaction_date: Date) {
        self.payment_id = payment_id
        self.booking_id = booking_id
        self.payment_method = payment_method
        self.payment_amount = payment_amount
        self.payment_status = payment_status
        self.transaction_date = transaction_date
    }
}

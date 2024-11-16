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
    var payment_method: PaymentMethod
    var payment_amount: Float
    var payment_status: PaymentStatus
    var transaction_date: Date?

    var id: Int {
        return payment_id
    }

    init(payment_id: Int, booking_id: Int, payment_method: PaymentMethod, payment_amount: Float, payment_status: PaymentStatus, transaction_date: Date? = nil) {
        self.payment_id = payment_id
        self.booking_id = booking_id
        self.payment_method = payment_method
        self.payment_amount = payment_amount
        self.payment_status = payment_status
        self.transaction_date = transaction_date
    }
}

enum PaymentMethod: String {
    case creditCard = "Credit Card"
    case debitCard = "Debit Card"
    case cash = "Cash"
}

enum PaymentStatus: String {
    case paid = "Paid"
    case pending = "Pending"
    case failed = "Failed"
}

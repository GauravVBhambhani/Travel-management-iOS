//
//  PaymentDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct PaymentDetailsView: View {
    let payment: Payment
    
    var body: some View {
        Form {
            Section(header: Text("Payment Details")) {
                Text("Payment Method: \(payment.payment_method)")
                Text("Payment Amount: $\(payment.payment_amount, specifier: "%.2f")")
                Text("Payment Status: \(payment.payment_status)")
            }
            Section(header: Text("Transaction Info")) {
                Text("Transaction Date: \(String(describing: payment.transaction_date))")
            }
        }
        .navigationTitle("Payment Details")
    }
}

//#Preview {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd"
//
//    PaymentDetailsView(payment: .init(
//        payment_id: 1,
//        booking_id: 1,
//        payment_method: .creditCard,
//        payment_amount: 1200.50,
//        payment_status: .paid,
//        transaction_date: dateFormatter.date(from: "2023-12-01")
//    ))
//}

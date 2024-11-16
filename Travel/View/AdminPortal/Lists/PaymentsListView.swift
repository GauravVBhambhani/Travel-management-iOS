//
//  PaymentsListView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import SwiftUI

struct PaymentsListView: View {
    
    @ObservedObject private var paymentsViewModel = PaymentViewModel()
        
    var body: some View {
        NavigationView {
            List {
                ForEach(paymentsViewModel.payments) { payment in
                    NavigationLink("Payment ID: \(payment.id)") {
                        PaymentDetailsView(payment: payment)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let paymentToDelete = paymentsViewModel.payments[index]
                        paymentsViewModel.deletePayment(paymentToDelete)
                    }
                }
            }
            .navigationTitle("Payments")
        }
    }
}

#Preview {
    PaymentsListView()
}

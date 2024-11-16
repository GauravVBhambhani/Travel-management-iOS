//
//  CustomerSupportListView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct CustomerSupportListView: View {
    
    @ObservedObject private var customerSupportViewModel = CustomerSupportViewModel()
        
    var body: some View {
        NavigationView {
            List {
                ForEach(customerSupportViewModel.customerSupportEntries, id: \.support_id) { support in
                    NavigationLink(destination: CustomerSupportDetailsView(customerSupport: support)) {
                        Text("User ID: \(support.user_id), Status: \(support.resolutionStatus)")
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let supportToDelete = customerSupportViewModel.customerSupportEntries[index]
                        customerSupportViewModel.deleteCustomerSupportEntry(supportToDelete)
                    }
                }
            }
            .navigationTitle("Customer Support")
        }
    }
}

#Preview {
    CustomerSupportListView()
}

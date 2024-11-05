//
//  UserDetailsView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import SwiftUI

struct UserDetailsView: View {
    let user: User
    
    var body: some View {
        Form {
            Section(header: Text("Personal Details")) {
                Text("Name: \(user.firstName) \(user.lastName)")
                Text(verbatim: "Phone: \(user.phone)")
                    
            }
            Section(header: Text("Contact")) {
                Text("Email: \(user.email)")
            }
            Section(header: Text("Address")) {
                Text("Street: \(user.street)")
                Text("City: \(user.city)")
                Text("State: \(user.state)")
                Text(String(format: "Pincode: %05d", user.pincode))
            }
        }
        .navigationTitle("User Details")
    }
}


#Preview {
    UserDetailsView(
        user: .init(
            user_id: 1,
            firstName: "Gaurav",
            lastName: "Bhambhani",
            phone: 8572040462,
            email: "bhambhani.g@outlook.com",
            password: "123",
            street: "Warren St",
            city: "Boston",
            state: "MA",
            pincode: 02119
        )
    )
}

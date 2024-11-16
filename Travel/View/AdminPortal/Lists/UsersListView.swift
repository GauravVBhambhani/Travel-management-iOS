//
//  UsersListView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import SwiftUI

struct UsersListView: View {
    @StateObject private var userViewModel = UserViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(userViewModel.users) { user in
                    NavigationLink(user.firstName + " " + user.lastName) {
                        UserDetailsView(user: user)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let userToDelete = userViewModel.users[index]
                        userViewModel.deleteUser(userToDelete)
                    }
                }
            }
            .navigationTitle("Users")
        }
    }
}


#Preview {
    UsersListView()
}

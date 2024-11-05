//
//  LoginView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import SwiftUI

struct LoginView: View {
    
    @State var email = ""
    @State var password = ""
    
    @State private var isAdmin = false
    @State private var navigateToAdminProtal = false
    @State private var navigateToHomeView = false
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                VStack {
                    TextField("Email", text: self.$email)
                        .textInputAutocapitalization(.never)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    
                    
                    SecureField("Password", text: self.$password)
                        .textContentType(.password)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                }
                .padding(.bottom, 30)
                
                Button("Log in") {
                    login()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                NavigationLink("", destination: AdminPortal(), isActive: $navigateToAdminProtal)
                    .hidden()
                
                NavigationLink("", destination: HomeView(), isActive: $navigateToHomeView)
                    .hidden()
                
            }
            .padding()
            .navigationTitle("Log in")
        }
    }
    
    private func login() {
        if email == "admin" && password == "admin" {
            isAdmin = true
            navigateToAdminProtal = true
        } else {
            navigateToHomeView = true
        }
    }
    
}

#Preview {
    LoginView()
}

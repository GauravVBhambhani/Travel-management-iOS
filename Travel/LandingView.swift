//
//  ContentView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import SwiftUI

//enum Navigate {
//    case userLogin
//    case userSignup
//}

struct LandingView: View {
    
    @State private var navigationPath = NavigationPath()
    
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                Spacer()
                NavigationLink(destination: LoginView()) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                NavigationLink(destination: SignupView()) {
                    Text("Create New Account")
                        .frame(maxWidth: .infinity)
                        .padding()
//                        .background(Color.yellow)
//                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
            }
            .padding()
            .navigationTitle("Tourism Manager")
        }
    }
}

#Preview {
    LandingView()
}
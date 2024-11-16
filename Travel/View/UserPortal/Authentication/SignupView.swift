//
//  SignupView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import SwiftUI
import SQLite3

struct SignupView: View {
    
    @ObservedObject var vm: UserViewModel
    
    @State var firstName = ""
    @State var lastName = ""
    @State var phone = ""
    
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    
    @State var street = ""
    @State var city = ""
    @State var state = ""
    @State var pincode = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section ("Personal Details") {
                TextField("First Name", text: self.$firstName)
                
                TextField("Last Name", text: self.$lastName)
                
                TextField("Phone Number", text: self.$phone)
            }
            
            Section ("Credentials") {
                TextField("Email", text: self.$email)
                
                TextField("Password", text: self.$password)
                
                TextField("Confirm Password", text: self.$confirmPassword)
            }
            
            Section ("Address Details") {
                TextField("Street", text: self.$street)
                
                TextField("City", text: self.$city)
                
                TextField("State", text: self.$state)
                
                TextField("Pincode", text: self.$pincode)
            }
            
            Button("Sign Up") {
                if validateInputs() {
                    insertUser()
                } else {
                    print("Please ensure all fields are filled correctly.")
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .navigationTitle("User Sign Up")
    }
    
    func validateInputs() -> Bool {
        // Basic validation example - ensure fields are non-empty
        return !firstName.isEmpty && !lastName.isEmpty && !phone.isEmpty &&
        !email.isEmpty && !password.isEmpty && (password == confirmPassword) &&
        !street.isEmpty && !city.isEmpty && !state.isEmpty && !pincode.isEmpty
    }
    
    func insertUser() {
        let newUser = User(
            user_id: 0,
            firstName: firstName,
            lastName: lastName,
            phone: phone,
            email: email,
            password: password,
            street: street,
            city: city,
            state: state,
            pincode: Int(pincode) ?? 0
        )
        
        vm.addUser(newUser)
        
        presentationMode.wrappedValue.dismiss()
    }

}

#Preview {
    SignupView(vm: UserViewModel())
}

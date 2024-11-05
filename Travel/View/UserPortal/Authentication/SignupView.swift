//
//  SignupView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import SwiftUI
import SQLite3

struct SignupView: View {
    
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
        let insertQuery = """
            INSERT INTO USERS (firstName, lastName, phone, email, password, street, city, state, pincode) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
            """
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (firstName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (lastName as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, Int32(phone) ?? 0)
            sqlite3_bind_text(insertStatement, 4, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (password as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (street as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, (city as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 8, (state as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 9, Int32(pincode) ?? 0)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("User successfully inserted.")
            } else {
                print("Could not insert user.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        
        sqlite3_finalize(insertStatement)
    }
}

#Preview {
    SignupView()
}

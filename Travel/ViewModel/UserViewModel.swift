//
//  UserViewModel.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import Foundation
import SQLite3

class UserViewModel: ObservableObject {
    
    @Published var users = [User]()
    
    init() {
        fetchUsers()
    }
    
    func fetchUsers() {
        users.removeAll()
        
        let query = "SELECT * FROM USERS"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let firstName = String(cString: sqlite3_column_text(queryStatement, 1))
                let lastName = String(cString: sqlite3_column_text(queryStatement, 2))
                let phone = sqlite3_column_int(queryStatement, 3)
                let email = String(cString: sqlite3_column_text(queryStatement, 4))
                let password = String(cString: sqlite3_column_text(queryStatement, 5))
                let street = String(cString: sqlite3_column_text(queryStatement, 6))
                let city = String(cString: sqlite3_column_text(queryStatement, 7))
                let state = String(cString: sqlite3_column_text(queryStatement, 8))
                let pincode = sqlite3_column_int(queryStatement, 9)
                
                let user = User(
                    user_id: Int(id),
                    firstName: firstName,
                    lastName: lastName,
                    phone: Int(phone),
                    email: email,
                    password: password,
                    street: street,
                    city: city,
                    state: state,
                    pincode: Int(pincode)
                )
                
                users.append(user)
            }
        }
        sqlite3_finalize(queryStatement)
    }
    
    func deleteUser(_ user: User) {
        let deleteStatementString = "DELETE FROM USERS WHERE id = ?"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(user.id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted user.")
                fetchUsers() // Refresh user list
            } else {
                print("Could not delete user.")
            }
        }
        sqlite3_finalize(deleteStatement)
    }
    
}

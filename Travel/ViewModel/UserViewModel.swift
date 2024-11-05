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
        } else {
            print("ERROR: Could not prepare SELECT statement.")
        }
        sqlite3_finalize(queryStatement)
    }
    
    func addUser(_ user: User) {
        let insertStatementString = """
            INSERT INTO USERS (firstName, lastName, phone, email, password, street, city, state, pincode)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
        """
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(insertStatement, 1, (user.firstName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (user.lastName as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, Int32(Int(user.phone)))
            sqlite3_bind_text(insertStatement, 4, (user.email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (user.password as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (user.street as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, (user.city as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 8, (user.state as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 9, Int32(user.pincode))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully added user.")
                fetchUsers()
            } else {
                print("ERROR: Could not insert user.")
            }
        } else {
            print("ERROR: Could not prepare INSERT statement.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    func updateUser(_ user: User) {
            let updateStatementString = """
                UPDATE USERS
                SET firstName = ?, lastName = ?, phone = ?, email = ?, password = ?, street = ?, city = ?, state = ?, pincode = ?
                WHERE id = ?;
                """
            var updateStatement: OpaquePointer?

            if sqlite3_prepare_v2(DatabaseManager.shared.db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                sqlite3_bind_text(updateStatement, 1, (user.firstName as NSString).utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 2, (user.lastName as NSString).utf8String, -1, nil)
                sqlite3_bind_int(updateStatement, 3, Int32(user.phone))
                sqlite3_bind_text(updateStatement, 4, (user.email as NSString).utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 5, (user.password as NSString).utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 6, (user.street as NSString).utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 7, (user.city as NSString).utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 8, (user.state as NSString).utf8String, -1, nil)
                sqlite3_bind_int(updateStatement, 9, Int32(user.pincode))
                sqlite3_bind_int(updateStatement, 10, Int32(user.user_id))

                if sqlite3_step(updateStatement) == SQLITE_DONE {
                    print("Successfully updated user.")
                    fetchUsers() // Refresh user list
                } else {
                    print("ERROR: Could not update user.")
                }
            } else {
                print("ERROR: Could not prepare UPDATE statement.")
            }
            sqlite3_finalize(updateStatement)
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
        } else {
            print("ERROR: Could not prepare DELETE statement.")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    
}

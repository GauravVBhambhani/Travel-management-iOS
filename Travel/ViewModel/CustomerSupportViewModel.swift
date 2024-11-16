//
//  CustomerSupportViewModel.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import Foundation
import SQLite3

class CustomerSupportViewModel: ObservableObject {
    @Published var customerSupportEntries = [CustomerSupport]()
    
    init() {
        fetchCustomerSupportEntries()
    }
    
    func fetchCustomerSupportEntries() {
        customerSupportEntries.removeAll()
        
        let query = "SELECT * FROM CUSTOMER_SUPPORT"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let supportId = sqlite3_column_int(queryStatement, 0)
                let userId = sqlite3_column_int(queryStatement, 1)
                let issueDescription = String(cString: sqlite3_column_text(queryStatement, 2))
                let resolutionStatus = String(cString: sqlite3_column_text(queryStatement, 3))
                let resolutionDateString = sqlite3_column_text(queryStatement, 4)
                
                var resolutionDate: Date? = nil
                if let resolutionDateString = resolutionDateString {
                    let dateFormatter = ISO8601DateFormatter()
                    resolutionDate = dateFormatter.date(from: String(cString: resolutionDateString))
                }
                
                let customerSupport = CustomerSupport(
                    support_id: Int(supportId),
                    user_id: Int(userId),
                    issueDescription: issueDescription,
                    resolutionStatus: resolutionStatus,
                    resolutionDate: resolutionDate
                )
                
                customerSupportEntries.append(customerSupport)
            }
        } else {
            print("ERROR: Could not prepare SELECT statement.")
        }
        sqlite3_finalize(queryStatement)
    }
    
    func addCustomerSupportEntry(_ customerSupport: CustomerSupport) {
        let insertStatementString = """
            INSERT INTO CUSTOMER_SUPPORT (user_id, issue_description, resolution_status, resolution_date)
            VALUES (?, ?, ?, ?);
        """
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(customerSupport.user_id))
            sqlite3_bind_text(insertStatement, 2, (customerSupport.issueDescription as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (customerSupport.resolutionStatus as NSString).utf8String, -1, nil)
            
            if let resolutionDate = customerSupport.resolutionDate {
                let dateFormatter = ISO8601DateFormatter()
                let resolutionDateString = dateFormatter.string(from: resolutionDate)
                sqlite3_bind_text(insertStatement, 4, (resolutionDateString as NSString).utf8String, -1, nil)
            } else {
                sqlite3_bind_null(insertStatement, 4)
            }
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully added customer support entry.")
                fetchCustomerSupportEntries()
            } else {
                print("ERROR: Could not insert customer support entry.")
            }
        } else {
            print("ERROR: Could not prepare INSERT statement.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    func updateCustomerSupportEntry(_ customerSupport: CustomerSupport) {
        let updateStatementString = """
            UPDATE CUSTOMER_SUPPORT
            SET issue_description = ?, resolution_status = ?, resolution_date = ?
            WHERE id = ?;
        """
        
        var updateStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (customerSupport.issueDescription as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (customerSupport.resolutionStatus as NSString).utf8String, -1, nil)
            
            if let resolutionDate = customerSupport.resolutionDate {
                let dateFormatter = ISO8601DateFormatter()
                let resolutionDateString = dateFormatter.string(from: resolutionDate)
                sqlite3_bind_text(updateStatement, 3, (resolutionDateString as NSString).utf8String, -1, nil)
            } else {
                sqlite3_bind_null(updateStatement, 3)
            }
            
            sqlite3_bind_int(updateStatement, 4, Int32(customerSupport.support_id))
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated customer support entry.")
                fetchCustomerSupportEntries()
            } else {
                print("ERROR: Could not update customer support entry.")
            }
        } else {
            print("ERROR: Could not prepare UPDATE statement.")
        }
        
        sqlite3_finalize(updateStatement)
    }
    
    func deleteCustomerSupportEntry(_ customerSupport: CustomerSupport) {
        let deleteStatementString = "DELETE FROM CUSTOMER_SUPPORT WHERE id = ?"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(customerSupport.support_id))
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted customer support entry.")
                fetchCustomerSupportEntries()
            } else {
                print("Could not delete customer support entry.")
            }
        } else {
            print("ERROR: Could not prepare DELETE statement.")
        }
        
        sqlite3_finalize(deleteStatement)
    }
}

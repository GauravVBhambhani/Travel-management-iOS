//
//  TransportViewModel.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import Foundation
import SQLite3

class TransportViewModel: ObservableObject {
    @Published var transports = [Transport]()
    
    init() {
        fetchTransports()
    }
    
    func fetchTransports() {
        transports.removeAll()
        
        let query = "SELECT * FROM TRANSPORT"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let type = String(cString: sqlite3_column_text(queryStatement, 1))
                let companyName = String(cString: sqlite3_column_text(queryStatement, 2))
                let departureTime = String(cString: sqlite3_column_text(queryStatement, 3))
                let arrivalTime = String(cString: sqlite3_column_text(queryStatement, 4))
                let price = sqlite3_column_double(queryStatement, 5)
                
                let transport = Transport(
                    transport_id: Int(id),
                    type: type,
                    company_name: companyName,
                    departure_time: departureTime,
                    arrival_time: arrivalTime,
                    price: Float(price)
                )
                
                transports.append(transport)
            }
        } else {
            print("ERROR: Could not prepare SELECT statement.")
        }
        sqlite3_finalize(queryStatement)
    }
    
    func addTransport(_ transport: Transport) {
        let insertStatementString = """
            INSERT INTO TRANSPORT (type, company_name, departure_time, arrival_time, price)
            VALUES (?, ?, ?, ?, ?);
        """
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (transport.type as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (transport.company_name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (transport.departure_time as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (transport.arrival_time as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStatement, 5, Double(transport.price))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully added transport.")
                fetchTransports()
            } else {
                print("ERROR: Could not insert transport.")
            }
        } else {
            print("ERROR: Could not prepare INSERT statement.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    func updateTransport(_ transport: Transport) {
        let updateStatementString = """
            UPDATE TRANSPORT
            SET type = ?, company_name = ?, departure_time = ?, arrival_time = ?, price = ?
            WHERE id = ?;
        """
        var updateStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (transport.type as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (transport.company_name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 3, (transport.departure_time as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 4, (transport.arrival_time as NSString).utf8String, -1, nil)
            sqlite3_bind_double(updateStatement, 5, Double(transport.price))
            sqlite3_bind_int(updateStatement, 6, Int32(transport.transport_id))
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated transport.")
                fetchTransports() // Refresh transport list
            } else {
                print("ERROR: Could not update transport.")
            }
        } else {
            print("ERROR: Could not prepare UPDATE statement.")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func deleteTransport(_ transport: Transport) {
        let deleteStatementString = "DELETE FROM TRANSPORT WHERE id = ?"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(transport.transport_id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted transport.")
                fetchTransports() // Refresh transport list
            } else {
                print("Could not delete transport.")
            }
        } else {
            print("ERROR: Could not prepare DELETE statement.")
        }
        
        sqlite3_finalize(deleteStatement)
    }
}

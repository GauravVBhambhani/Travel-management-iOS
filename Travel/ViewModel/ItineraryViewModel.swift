//
//  ItineraryViewModel.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import Foundation
import SQLite3

class ItineraryViewModel: ObservableObject {
    
    @Published var itineraries = [Itinerary]()
    
    init() {
        fetchItineraries()
    }
    
    func fetchItineraries() {
        itineraries.removeAll()
        
        let query = "SELECT * FROM ITINERARIES"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let user_id = sqlite3_column_int(queryStatement, 1)
                let start_date_string = String(cString: sqlite3_column_text(queryStatement, 2))
                let end_date_string = String(cString: sqlite3_column_text(queryStatement, 3))
                let destination = String(cString: sqlite3_column_text(queryStatement, 4))
                let total_cost = sqlite3_column_double(queryStatement, 5)
                
                let formatter = ISO8601DateFormatter()
                guard let start_date = formatter.date(from: start_date_string),
                      let end_date = formatter.date(from: end_date_string) else {
                    print("ERROR: Could not parse start or end date.")
                    continue
                }
                
                let itinerary = Itinerary(
                    itinerary_id: Int(id),
                    user_id: Int(user_id),
                    start_date: start_date,
                    end_date: end_date,
                    destination: destination,
                    total_cost: total_cost
                )
                
                itineraries.append(itinerary)
            }
        } else {
            print("ERROR: Could not prepare SELECT statement.")
        }
        sqlite3_finalize(queryStatement)
    }
    
    func addItinerary(_ itinerary: Itinerary) {
        let insertStatementString = """
            INSERT INTO ITINERARIES (user_id, start_date, end_date, destination, total_cost)
            VALUES (?, ?, ?, ?, ?);
        """
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(insertStatement, 1, Int32(itinerary.user_id))
            
            let formatter = ISO8601DateFormatter()
            let start_date_string = formatter.string(from: itinerary.start_date)
            let end_date_string = formatter.string(from: itinerary.end_date)
            
            sqlite3_bind_text(insertStatement, 2, (start_date_string as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (end_date_string as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (itinerary.destination as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStatement, 5, itinerary.total_cost)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully added itinerary.")
                fetchItineraries()
            } else {
                print("ERROR: Could not insert itinerary.")
            }
        } else {
            print("ERROR: Could not prepare INSERT statement.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    func updateItinerary(_ itinerary: Itinerary) {
        let updateStatementString = """
            UPDATE ITINERARIES
            SET user_id = ?, start_date = ?, end_date = ?, destination = ?, total_cost = ?
            WHERE id = ?;
        """
        var updateStatement: OpaquePointer?

        if sqlite3_prepare_v2(DatabaseManager.shared.db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStatement, 1, Int32(itinerary.user_id))
            
            let formatter = ISO8601DateFormatter()
            let start_date_string = formatter.string(from: itinerary.start_date)
            let end_date_string = formatter.string(from: itinerary.end_date)
            
            sqlite3_bind_text(updateStatement, 2, (start_date_string as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 3, (end_date_string as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 4, (itinerary.destination as NSString).utf8String, -1, nil)
            sqlite3_bind_double(updateStatement, 5, itinerary.total_cost)
            sqlite3_bind_int(updateStatement, 6, Int32(itinerary.itinerary_id))

            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated itinerary.")
                fetchItineraries() // Refresh itinerary list
            } else {
                print("ERROR: Could not update itinerary.")
            }
        } else {
            print("ERROR: Could not prepare UPDATE statement.")
        }
        sqlite3_finalize(updateStatement)
    }

    func deleteItinerary(_ itinerary: Itinerary) {
        let deleteStatementString = "DELETE FROM ITINERARIES WHERE id = ?"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(itinerary.itinerary_id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted itinerary.")
                fetchItineraries() // Refresh itinerary list
            } else {
                print("Could not delete itinerary.")
            }
        } else {
            print("ERROR: Could not prepare DELETE statement.")
        }
        
        sqlite3_finalize(deleteStatement)
    }
}

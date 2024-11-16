//
//  TouristDestinationViewModel.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import Foundation
import SQLite3

class TouristDestinationViewModel: ObservableObject {
    
    @Published var destinations = [TouristDestination]()
    
    init() {
        fetchDestinations()
    }
    
    func fetchDestinations() {
        destinations.removeAll()
        
        let query = "SELECT * FROM TOURIST_DESTINATION"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let agencyID = sqlite3_column_int(queryStatement, 1)
                let name = String(cString: sqlite3_column_text(queryStatement, 2))
                let location = String(cString: sqlite3_column_text(queryStatement, 3))
                let popularAttractions = String(cString: sqlite3_column_text(queryStatement, 4))
                let rating = sqlite3_column_int(queryStatement, 5)
                let description = String(cString: sqlite3_column_text(queryStatement, 6))
                
                let destination = TouristDestination(
                    destination_id: Int(id),
                    agency_id: Int(agencyID),
                    name: name,
                    location: location,
                    popular_attractions: popularAttractions,
                    rating: Int(rating),
                    description: description
                )
                
                destinations.append(destination)
            }
        } else {
            print("ERROR: Could not prepare SELECT statement.")
        }
        sqlite3_finalize(queryStatement)
    }
    
    func addDestination(_ destination: TouristDestination) {
        let insertStatementString = """
            INSERT INTO TOURIST_DESTINATION (agency_id, name, location, popular_attractions, rating, description)
            VALUES (?, ?, ?, ?, ?, ?);
        """
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(insertStatement, 1, Int32(destination.agency_id))
            sqlite3_bind_text(insertStatement, 2, (destination.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (destination.location as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (destination.popular_attractions as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 5, Int32(destination.rating))
            sqlite3_bind_text(insertStatement, 6, (destination.description as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully added destination.")
                fetchDestinations()
            } else {
                print("ERROR: Could not insert destination.")
            }
        } else {
            print("ERROR: Could not prepare INSERT statement.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    func updateDestination(_ destination: TouristDestination) {
        let updateStatementString = """
            UPDATE TOURIST_DESTINATION
            SET agency_id = ?, name = ?, location = ?, popular_attractions = ?, rating = ?, description = ?
            WHERE id = ?;
        """
        var updateStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStatement, 1, Int32(destination.agency_id))
            sqlite3_bind_text(updateStatement, 2, (destination.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 3, (destination.location as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 4, (destination.popular_attractions as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 5, Int32(destination.rating))
            sqlite3_bind_text(updateStatement, 6, (destination.description as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 7, Int32(destination.id))
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated destination.")
                fetchDestinations() // Refresh list
            } else {
                print("ERROR: Could not update destination.")
            }
        } else {
            print("ERROR: Could not prepare UPDATE statement.")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func deleteDestination(_ destination: TouristDestination) {
        let deleteStatementString = "DELETE FROM TOURIST_DESTINATION WHERE id = ?"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(destination.id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted destination.")
                fetchDestinations() // Refresh list
            } else {
                print("ERROR: Could not delete destination.")
            }
        } else {
            print("ERROR: Could not prepare DELETE statement.")
        }
        
        sqlite3_finalize(deleteStatement)
    }
}

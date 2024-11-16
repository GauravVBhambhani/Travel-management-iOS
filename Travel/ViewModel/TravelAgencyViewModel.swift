//
//  TravelAgencyViewModel.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/5/24.
//

import Foundation
import SQLite3

class TravelAgencyViewModel: ObservableObject {
    @Published var travelAgencies = [TravelAgency]()
    
    init() {
        fetchTravelAgencies()
    }
    
    func fetchTravelAgencies() {
        travelAgencies.removeAll()
        
        let query = "SELECT * FROM TRAVEL_AGENCY"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(cString: sqlite3_column_text(queryStatement, 1))
                let location = String(cString: sqlite3_column_text(queryStatement, 2))
                let contactInfo = String(cString: sqlite3_column_text(queryStatement, 3))
                let rating = sqlite3_column_int(queryStatement, 4)
                
                let travelAgency = TravelAgency(
                    agency_id: Int(id),
                    name: name,
                    location: location,
                    contact_info: contactInfo,
                    rating: Int(rating)
                )
                
                travelAgencies.append(travelAgency)
            }
            print("Travel Agencies fetched successfully.")
        } else {
            print("ERROR: Could not prepare SELECT statement for travel agencies.")
        }
        
        sqlite3_finalize(queryStatement)
    }
    
    func addTravelAgency(_ travelAgency: TravelAgency) {
        let insertStatementString = """
            INSERT INTO TRAVEL_AGENCY (name, location, contact_info, rating)
            VALUES (?, ?, ?, ?);
        """
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (travelAgency.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (travelAgency.location as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (travelAgency.contact_info as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 4, Int32(travelAgency.rating))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully added travel agency.")
                fetchTravelAgencies()
            } else {
                print("ERROR: Could not insert travel agency.")
            }
        } else {
            print("ERROR: Could not prepare INSERT statement for travel agency.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    func updateTravelAgency(_ travelAgency: TravelAgency) {
        let updateStatementString = """
            UPDATE TRAVEL_AGENCY
            SET name = ?, location = ?, contact_info = ?, rating = ?
            WHERE id = ?;
        """
        
        var updateStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (travelAgency.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (travelAgency.location as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 3, (travelAgency.contact_info as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 4, Int32(travelAgency.rating))
            sqlite3_bind_int(updateStatement, 5, Int32(travelAgency.agency_id))
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated travel agency.")
                fetchTravelAgencies() // Refresh travel agencies list
            } else {
                print("ERROR: Could not update travel agency.")
            }
        } else {
            print("ERROR: Could not prepare UPDATE statement for travel agency.")
        }
        
        sqlite3_finalize(updateStatement)
        
        if let index = travelAgencies.firstIndex(where: { $0.agency_id == travelAgency.agency_id }) {
            travelAgencies[index] = travelAgency
        }
        
        travelAgencies = travelAgencies
    }
    
    func deleteTravelAgency(_ travelAgency: TravelAgency) {
        let deleteStatementString = "DELETE FROM TRAVEL_AGENCY WHERE id = ?;"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(travelAgency.agency_id))
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted travel agency.")
                fetchTravelAgencies() // Refresh travel agencies list
            } else {
                print("ERROR: Could not delete travel agency.")
            }
        } else {
            print("ERROR: Could not prepare DELETE statement for travel agency.")
        }
        
        sqlite3_finalize(deleteStatement)
    }
}

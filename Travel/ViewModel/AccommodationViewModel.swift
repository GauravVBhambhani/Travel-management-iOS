//
//  AccommodationViewModel.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import Foundation
import SQLite3

class AccommodationViewModel: ObservableObject {
    @Published var accommodations = [Accommodation]()
    
    init() {
        fetchAccommodations()
    }
    
    func fetchAccommodations() {
        accommodations.removeAll()
        
        let query = "SELECT * FROM ACCOMMODATION"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let destinationID = sqlite3_column_int(queryStatement, 1)
                let name = String(cString: sqlite3_column_text(queryStatement, 2))
                let street = String(cString: sqlite3_column_text(queryStatement, 3))
                let city = String(cString: sqlite3_column_text(queryStatement, 4))
                let state = String(cString: sqlite3_column_text(queryStatement, 5))
                let zipcode = sqlite3_column_int(queryStatement, 6)
                let type = String(cString: sqlite3_column_text(queryStatement, 7))
                let pricePerNight = sqlite3_column_double(queryStatement, 8)
                let availabilityStatus = String(cString: sqlite3_column_text(queryStatement, 9))
                let rating = sqlite3_column_int(queryStatement, 10)
                
                let accommodation = Accommodation(
                    accommodation_id: Int(id),
                    destination_id: Int(destinationID),
                    name: name,
                    street: street,
                    city: city,
                    state: state,
                    zipcode: Int(zipcode),
                    type: type,
                    price_per_night: Float(pricePerNight),
                    availability_status: availabilityStatus,
                    rating: Int(rating)
                )
                
                accommodations.append(accommodation)
            }
        } else {
            print("ERROR: Could not prepare SELECT statement for accommodations.")
        }
        sqlite3_finalize(queryStatement)
    }
    
    func addAccommodation(_ accommodation: Accommodation) {
        let insertStatementString = """
            INSERT INTO ACCOMMODATION (destination_id, name, street, city, state, zipcode, type, price_per_night, availability_status, rating)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
        """
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(accommodation.destination_id))
            sqlite3_bind_text(insertStatement, 2, (accommodation.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (accommodation.street as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (accommodation.city as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (accommodation.state as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 6, Int32(accommodation.zipcode))
            sqlite3_bind_text(insertStatement, 7, (accommodation.type as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStatement, 8, Double(accommodation.price_per_night))
            sqlite3_bind_text(insertStatement, 9, (accommodation.availability_status as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 10, Int32(accommodation.rating))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully added accommodation.")
                fetchAccommodations()
            } else {
                print("ERROR: Could not insert accommodation.")
            }
        } else {
            print("ERROR: Could not prepare INSERT statement for accommodation.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    func updateAccommodation(_ accommodation: Accommodation) {
        let updateStatementString = """
            UPDATE ACCOMMODATION
            SET destination_id = ?, name = ?, street = ?, city = ?, state = ?, zipcode = ?, type = ?, price_per_night = ?, availability_status = ?, rating = ?
            WHERE id = ?;
        """
        
        var updateStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStatement, 1, Int32(accommodation.destination_id))
            sqlite3_bind_text(updateStatement, 2, (accommodation.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 3, (accommodation.street as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 4, (accommodation.city as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 5, (accommodation.state as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 6, Int32(accommodation.zipcode))
            sqlite3_bind_text(updateStatement, 7, (accommodation.type as NSString).utf8String, -1, nil)
            sqlite3_bind_double(updateStatement, 8, Double(accommodation.price_per_night))
            sqlite3_bind_text(updateStatement, 9, (accommodation.availability_status as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 10, Int32(accommodation.rating))
            sqlite3_bind_int(updateStatement, 11, Int32(accommodation.accommodation_id))
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated accommodation.")
                fetchAccommodations() // Refresh accommodation list
            } else {
                print("ERROR: Could not update accommodation.")
            }
        } else {
            print("ERROR: Could not prepare UPDATE statement for accommodation.")
        }
        
        sqlite3_finalize(updateStatement)
    }
    
    func deleteAccommodation(_ accommodation: Accommodation) {
        let deleteStatementString = "DELETE FROM ACCOMMODATION WHERE id = ?"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(accommodation.accommodation_id))
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted accommodation.")
                fetchAccommodations() // Refresh accommodation list
            } else {
                print("ERROR: Could not delete accommodation.")
            }
        } else {
            print("ERROR: Could not prepare DELETE statement for accommodation.")
        }
        
        sqlite3_finalize(deleteStatement)
    }
}

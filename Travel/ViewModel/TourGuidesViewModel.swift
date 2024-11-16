//
//  TourGuidesViewModel.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/5/24.
//

import Foundation
import SQLite3

class TourGuidesViewModel: ObservableObject {
    
    @Published var tourGuides = [TourGuide]()
    
    init() {
        fetchTourGuides()
    }
    
    func fetchTourGuides() {
        tourGuides.removeAll()
        
        let query = "SELECT * FROM TOUR_GUIDES"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let firstName = String(cString: sqlite3_column_text(queryStatement, 1))
                let lastName = String(cString: sqlite3_column_text(queryStatement, 2))
                let contact = String(cString: sqlite3_column_text(queryStatement, 3))
                let language = String(cString: sqlite3_column_text(queryStatement, 4))
                let yearsOfExperience = sqlite3_column_int(queryStatement, 5)
                let rating = sqlite3_column_int(queryStatement, 6)
                
                let tourGuide = TourGuide(
                    tourguide_id: Int(id),
                    firstName: firstName,
                    lastName: lastName,
                    language: language,
                    yearsOfExperience: Int(yearsOfExperience),
                    contact: contact,
                    rating: Int(rating)
                )
                
                tourGuides.append(tourGuide)
            }
        } else {
            print("ERROR: Could not prepare SELECT statement.")
        }
        sqlite3_finalize(queryStatement)
    }
    
    func addTourGuide(_ tourGuide: TourGuide) {
        let insertStatementString = """
            INSERT INTO TOUR_GUIDES (firstName, lastName, contact, language, yearsOfExperience, rating)
            VALUES (?, ?, ?, ?, ?, ?);
        """
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(insertStatement, 1, (tourGuide.firstName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (tourGuide.lastName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (tourGuide.contact as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (tourGuide.language as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 5, Int32(tourGuide.yearsOfExperience))
            sqlite3_bind_int(insertStatement, 6, Int32(tourGuide.rating))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully added tour guide.")
                fetchTourGuides()
            } else {
                print("ERROR: Could not insert tour guides.")
            }
        } else {
            print("ERROR: Could not prepare INSERT statement.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    func updateTourGuide(_ tourGuide: TourGuide) {
            let updateStatementString = """
                UPDATE TOUR_GUIDES
                SET firstName = ?, lastName = ?, contact = ?, language = ?, yearsOfExperience = ?, rating = ?
                WHERE id = ?;
                """
            var updateStatement: OpaquePointer?

            if sqlite3_prepare_v2(DatabaseManager.shared.db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                sqlite3_bind_text(updateStatement, 1, (tourGuide.firstName as NSString).utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 2, (tourGuide.lastName as NSString).utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 3, (tourGuide.contact as NSString).utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 4, (tourGuide.language as NSString).utf8String, -1, nil)
                sqlite3_bind_int(updateStatement, 5, Int32(tourGuide.yearsOfExperience))
                sqlite3_bind_int(updateStatement, 6, Int32(tourGuide.rating))
                
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                    print("Successfully updated Tour Guide.")
                    fetchTourGuides() // Refresh user list
                } else {
                    print("ERROR: Could not update Tour Guide.")
                }
            } else {
                print("ERROR: Could not prepare UPDATE statement.")
            }
            sqlite3_finalize(updateStatement)
        }

    func deleteTourGuide(_ tourGuide: TourGuide) {
        let deleteStatementString = "DELETE FROM TOUR_GUIDES WHERE id = ?"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(tourGuide.id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted Tour Guide.")
                fetchTourGuides()
            } else {
                print("Could not delete Tour Guide.")
            }
        } else {
            print("ERROR: Could not prepare DELETE statement.")
        }
        
        sqlite3_finalize(deleteStatement)
    }
}

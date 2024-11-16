//
//  ReviewViewModel.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import Foundation
import SQLite3

class ReviewViewModel: ObservableObject {
    
    @Published var reviews = [Review]()
    
    init() {
        fetchReviews()
    }
    
    func fetchReviews() {
        reviews.removeAll()
        
        let query = "SELECT * FROM REVIEWS"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let user_id = sqlite3_column_int(queryStatement, 1)
                let destination_id = sqlite3_column_int(queryStatement, 2)
                let accommodation_id = sqlite3_column_int(queryStatement, 3)
                let activity_id = sqlite3_column_int(queryStatement, 4)
                let rating = sqlite3_column_int(queryStatement, 5)
                let review_text = String(cString: sqlite3_column_text(queryStatement, 6))
                let review_date = String(cString: sqlite3_column_text(queryStatement, 7))
                
                let review = Review(
                    review_id: Int(id),
                    user_id: Int(user_id),
                    destination_id: Int(destination_id),
                    accommodation_id: accommodation_id == 0 ? nil : Int(accommodation_id),
                    activity_id: activity_id == 0 ? nil : Int(activity_id),
                    rating: Int(rating),
                    review_text: review_text,
                    review_date: review_date
                )
                
                reviews.append(review)
            }
        } else {
            print("ERROR: Could not prepare SELECT statement.")
        }
        sqlite3_finalize(queryStatement)
    }
    
    func addReview(_ review: Review) {
        let insertStatementString = """
            INSERT INTO REVIEWS (user_id, destination_id, accommodation_id, activity_id, rating, review_text, review_date)
            VALUES (?, ?, ?, ?, ?, ?, ?);
        """
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(insertStatement, 1, Int32(review.user_id))
            sqlite3_bind_int(insertStatement, 2, Int32(review.destination_id))
            
            if let accommodationID = review.accommodation_id {
                sqlite3_bind_int(insertStatement, 3, Int32(accommodationID))
            } else {
                sqlite3_bind_null(insertStatement, 3)
            }
            
            if let activityID = review.activity_id {
                sqlite3_bind_int(insertStatement, 4, Int32(activityID))
            } else {
                sqlite3_bind_null(insertStatement, 4)
            }
            
            sqlite3_bind_int(insertStatement, 5, Int32(review.rating))
            sqlite3_bind_text(insertStatement, 6, (review.review_text as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, (review.review_date as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully added review.")
                fetchReviews()
            } else {
                print("ERROR: Could not insert review.")
            }
        } else {
            print("ERROR: Could not prepare INSERT statement.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    func updateReview(_ review: Review) {
        let updateStatementString = """
            UPDATE REVIEWS
            SET user_id = ?, destination_id = ?, accommodation_id = ?, activity_id = ?, rating = ?, review_text = ?, review_date = ?
            WHERE id = ?;
        """
        var updateStatement: OpaquePointer?

        if sqlite3_prepare_v2(DatabaseManager.shared.db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStatement, 1, Int32(review.user_id))
            sqlite3_bind_int(updateStatement, 2, Int32(review.destination_id))
            
            if let accommodationID = review.accommodation_id {
                sqlite3_bind_int(updateStatement, 3, Int32(accommodationID))
            } else {
                sqlite3_bind_null(updateStatement, 3)
            }
            
            if let activityID = review.activity_id {
                sqlite3_bind_int(updateStatement, 4, Int32(activityID))
            } else {
                sqlite3_bind_null(updateStatement, 4)
            }
            
            sqlite3_bind_int(updateStatement, 5, Int32(review.rating))
            sqlite3_bind_text(updateStatement, 6, (review.review_text as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 7, (review.review_date as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 8, Int32(review.review_id))

            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated review.")
                fetchReviews() // Refresh review list
            } else {
                print("ERROR: Could not update review.")
            }
        } else {
            print("ERROR: Could not prepare UPDATE statement.")
        }
        sqlite3_finalize(updateStatement)
    }

    func deleteReview(_ review: Review) {
        let deleteStatementString = "DELETE FROM REVIEWS WHERE id = ?"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(review.review_id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted review.")
                fetchReviews() // Refresh review list
            } else {
                print("Could not delete review.")
            }
        } else {
            print("ERROR: Could not prepare DELETE statement.")
        }
        
        sqlite3_finalize(deleteStatement)
    }
}

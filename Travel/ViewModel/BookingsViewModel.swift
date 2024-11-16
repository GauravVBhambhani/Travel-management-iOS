//
//  BookingsViewModel.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import Foundation
import SQLite3

class BookingsViewModel: ObservableObject {
    
    @Published var bookings = [Booking]()
    
    init() {
        fetchBookings()
    }
    
    func fetchBookings() {
        bookings.removeAll()
        
        let query = "SELECT * FROM BOOKINGS"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let itinerary_id = sqlite3_column_int(queryStatement, 1)
                let user_id = sqlite3_column_int(queryStatement, 2)
                let booking_date = String(cString: sqlite3_column_text(queryStatement, 3))
                let total_cost = sqlite3_column_double(queryStatement, 4)
                let payment_status = String(cString: sqlite3_column_text(queryStatement, 5))
                
                let accommodation_id = sqlite3_column_int(queryStatement, 6)
                let activity_id = sqlite3_column_int(queryStatement, 7)
                let schedule_id = sqlite3_column_int(queryStatement, 8)
                
                let booking = Booking(
                    booking_id: Int(id),
                    user_id: Int(user_id),
                    booking_date: booking_date,
                    total_cost: Float(total_cost),
                    payment_status: payment_status,
                    accommodation_id: accommodation_id == 0 ? nil : Int(accommodation_id),
                    activity_id: activity_id == 0 ? nil : Int(activity_id),
                    schedule_id: schedule_id == 0 ? nil : Int(schedule_id),
                    itinerary_id: Int(itinerary_id)
                )
                
                bookings.append(booking)
            }
        } else {
            print("ERROR: Could not prepare SELECT statement.")
        }
        sqlite3_finalize(queryStatement)
    }
    
    func addBooking(_ booking: Booking) {
        let insertStatementString = """
            INSERT INTO BOOKINGS (itinerary_id, user_id, booking_date, total_cost, payment_status, accommodation_id, activity_id, schedule_id)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?);
        """
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(insertStatement, 1, Int32(booking.itinerary_id!))
            sqlite3_bind_int(insertStatement, 2, Int32(booking.user_id))
            sqlite3_bind_text(insertStatement, 3, (booking.booking_date as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStatement, 4, Double(booking.total_cost))
            sqlite3_bind_text(insertStatement, 5, (booking.payment_status as NSString).utf8String, -1, nil)
            
            if let accommodationID = booking.accommodation_id {
                sqlite3_bind_int(insertStatement, 6, Int32(accommodationID))
            } else {
                sqlite3_bind_null(insertStatement, 6)
            }
            
            if let activityID = booking.activity_id {
                sqlite3_bind_int(insertStatement, 7, Int32(activityID))
            } else {
                sqlite3_bind_null(insertStatement, 7)
            }
            
            if let scheduleID = booking.schedule_id {
                sqlite3_bind_int(insertStatement, 8, Int32(scheduleID))
            } else {
                sqlite3_bind_null(insertStatement, 8)
            }
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully added booking.")
                fetchBookings()
            } else {
                print("ERROR: Could not insert booking.")
            }
        } else {
            print("ERROR: Could not prepare INSERT statement.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    func updateBooking(_ booking: Booking) {
        let updateStatementString = """
            UPDATE BOOKINGS
            SET itinerary_id = ?, user_id = ?, booking_date = ?, total_cost = ?, payment_status = ?, accommodation_id = ?, activity_id = ?, schedule_id = ?
            WHERE id = ?;
        """
        var updateStatement: OpaquePointer?

        if sqlite3_prepare_v2(DatabaseManager.shared.db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStatement, 1, Int32(booking.itinerary_id!))
            sqlite3_bind_int(updateStatement, 2, Int32(booking.user_id))
            sqlite3_bind_text(updateStatement, 3, (booking.booking_date as NSString).utf8String, -1, nil)
            sqlite3_bind_double(updateStatement, 4, Double(booking.total_cost))
            sqlite3_bind_text(updateStatement, 5, (booking.payment_status as NSString).utf8String, -1, nil)
            
            if let accommodationID = booking.accommodation_id {
                sqlite3_bind_int(updateStatement, 6, Int32(accommodationID))
            } else {
                sqlite3_bind_null(updateStatement, 6)
            }
            
            if let activityID = booking.activity_id {
                sqlite3_bind_int(updateStatement, 7, Int32(activityID))
            } else {
                sqlite3_bind_null(updateStatement, 7)
            }
            
            if let scheduleID = booking.schedule_id {
                sqlite3_bind_int(updateStatement, 8, Int32(scheduleID))
            } else {
                sqlite3_bind_null(updateStatement, 8)
            }
            
            sqlite3_bind_int(updateStatement, 9, Int32(booking.booking_id))

            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated booking.")
                fetchBookings() // Refresh booking list
            } else {
                print("ERROR: Could not update booking.")
            }
        } else {
            print("ERROR: Could not prepare UPDATE statement.")
        }
        sqlite3_finalize(updateStatement)
    }

    func deleteBooking(_ booking: Booking) {
        let deleteStatementString = "DELETE FROM BOOKINGS WHERE id = ?"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(booking.booking_id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted booking.")
                fetchBookings() // Refresh booking list
            } else {
                print("Could not delete booking.")
            }
        } else {
            print("ERROR: Could not prepare DELETE statement.")
        }
        
        sqlite3_finalize(deleteStatement)
    }
}

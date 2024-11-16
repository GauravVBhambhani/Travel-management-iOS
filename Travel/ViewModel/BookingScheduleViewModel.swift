//
//  BookingScheduleViewModel.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import Foundation
import SQLite3

class BookingScheduleViewModel: ObservableObject {
    @Published var bookingSchedules = [BookingSchedule]()
    
    init() {
        fetchBookingSchedules()
    }
    
    func fetchBookingSchedules() {
        bookingSchedules.removeAll()
        
        let query = "SELECT * FROM BOOKING_SCHEDULES"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let scheduleId = sqlite3_column_int(queryStatement, 0)
                let bookingId = sqlite3_column_int(queryStatement, 1)
                let startDateString = String(cString: sqlite3_column_text(queryStatement, 2))
                let endDateString = String(cString: sqlite3_column_text(queryStatement, 3))
                
                let dateFormatter = ISO8601DateFormatter()
                guard let startDate = dateFormatter.date(from: startDateString),
                      let endDate = dateFormatter.date(from: endDateString) else {
                    continue
                }
                
                let bookingSchedule = BookingSchedule(
                    schedule_id: Int(scheduleId),
                    booking_id: Int(bookingId),
                    startDate: startDate,
                    endDate: endDate
                )
                
                bookingSchedules.append(bookingSchedule)
            }
        } else {
            print("ERROR: Could not prepare SELECT statement.")
        }
        sqlite3_finalize(queryStatement)
    }
    
    func addBookingSchedule(_ bookingSchedule: BookingSchedule) {
        let insertStatementString = """
            INSERT INTO BOOKING_SCHEDULES (schedule_id, booking_id, start_date, end_date)
            VALUES (?, ?, ?, ?);
        """
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(bookingSchedule.schedule_id))
            sqlite3_bind_int(insertStatement, 2, Int32(bookingSchedule.booking_id))
            
            let dateFormatter = ISO8601DateFormatter()
            let startDateString = dateFormatter.string(from: bookingSchedule.startDate)
            let endDateString = dateFormatter.string(from: bookingSchedule.endDate)
            
            sqlite3_bind_text(insertStatement, 3, (startDateString as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (endDateString as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully added booking schedule.")
                fetchBookingSchedules()
            } else {
                print("ERROR: Could not insert booking schedule.")
            }
        } else {
            print("ERROR: Could not prepare INSERT statement.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    func deleteBookingSchedule(_ bookingSchedule: BookingSchedule) {
        let deleteStatementString = "DELETE FROM BOOKING_SCHEDULES WHERE schedule_id = ? AND booking_id = ?"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(bookingSchedule.schedule_id))
            sqlite3_bind_int(deleteStatement, 2, Int32(bookingSchedule.booking_id))
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted booking schedule.")
                fetchBookingSchedules()
            } else {
                print("Could not delete booking schedule.")
            }
        } else {
            print("ERROR: Could not prepare DELETE statement.")
        }
        
        sqlite3_finalize(deleteStatement)
    }
}

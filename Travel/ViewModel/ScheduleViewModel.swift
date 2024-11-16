//
//  ScheduleViewModel.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import Foundation
import SQLite3

class ScheduleViewModel: ObservableObject {
    
    @Published var schedules = [Schedule]()
    
    init() {
        fetchSchedules()
    }
    
    func fetchSchedules() {
        schedules.removeAll()
        
        let query = "SELECT * FROM SCHEDULE"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let assetID = sqlite3_column_int(queryStatement, 1)
                let departureTime = String(cString: sqlite3_column_text(queryStatement, 2))
                let arrivalTime = String(cString: sqlite3_column_text(queryStatement, 3))
                let price = sqlite3_column_double(queryStatement, 4)
                
                let schedule = Schedule(
                    schedule_id: Int(id),
                    assetID: Int(assetID),
                    departureTime: departureTime,
                    arrivalTime: arrivalTime,
                    price: Float(price)
                )
                
                schedules.append(schedule)
            }
        } else {
            print("ERROR: Could not prepare SELECT statement.")
        }
        sqlite3_finalize(queryStatement)
    }
    
    func addSchedule(_ schedule: Schedule) {
        let insertStatementString = """
            INSERT INTO SCHEDULE (asset_id, departure_time, arrival_time, price)
            VALUES (?, ?, ?, ?);
        """
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(insertStatement, 1, Int32(schedule.assetID))
            sqlite3_bind_text(insertStatement, 2, (schedule.departureTime as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (schedule.arrivalTime as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStatement, 4, Double(schedule.price))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully added schedule.")
                fetchSchedules()
            } else {
                print("ERROR: Could not insert schedule.")
            }
        } else {
            print("ERROR: Could not prepare INSERT statement.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    func updateSchedule(_ schedule: Schedule) {
        let updateStatementString = """
            UPDATE SCHEDULE
            SET asset_id = ?, departure_time = ?, arrival_time = ?, price = ?
            WHERE id = ?;
        """
        var updateStatement: OpaquePointer?

        if sqlite3_prepare_v2(DatabaseManager.shared.db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStatement, 1, Int32(schedule.assetID))
            sqlite3_bind_text(updateStatement, 2, (schedule.departureTime as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 3, (schedule.arrivalTime as NSString).utf8String, -1, nil)
            sqlite3_bind_double(updateStatement, 4, Double(schedule.price))
            sqlite3_bind_int(updateStatement, 5, Int32(schedule.schedule_id))

            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated schedule.")
                fetchSchedules() // Refresh schedule list
            } else {
                print("ERROR: Could not update schedule.")
            }
        } else {
            print("ERROR: Could not prepare UPDATE statement.")
        }
        sqlite3_finalize(updateStatement)
    }

    func deleteSchedule(_ schedule: Schedule) {
        let deleteStatementString = "DELETE FROM SCHEDULE WHERE id = ?"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(schedule.schedule_id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted schedule.")
                fetchSchedules() // Refresh schedule list
            } else {
                print("Could not delete schedule.")
            }
        } else {
            print("ERROR: Could not prepare DELETE statement.")
        }
        
        sqlite3_finalize(deleteStatement)
    }
}

//
//  ActivityViewModel.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import Foundation
import SQLite3

class ActivityViewModel: ObservableObject {
    
    @Published var activities = [Activity]()
    
    init() {
        fetchActivities()
    }
    
    func fetchActivities() {
        activities.removeAll()
        
        let query = "SELECT * FROM ACTIVITIES"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let destination_id = sqlite3_column_int(queryStatement, 1)
                let name = String(cString: sqlite3_column_text(queryStatement, 2))
                let description = String(cString: sqlite3_column_text(queryStatement, 3))
                let location = String(cString: sqlite3_column_text(queryStatement, 4))
                let duration = sqlite3_column_int(queryStatement, 5)
                let price = sqlite3_column_double(queryStatement, 6)
                
                let activity = Activity(
                    activity_id: Int(id),
                    destination_id: Int(destination_id),
                    name: name,
                    description: description,
                    location: location,
                    duration: "\(duration)",
                    price: "\(price)"
                )
                
                activities.append(activity)
            }
        } else {
            print("ERROR: Could not prepare SELECT statement.")
        }
        sqlite3_finalize(queryStatement)
    }
    
    func addActivity(_ activity: Activity) {
        let insertStatementString = """
            INSERT INTO ACTIVITIES (destination_id, name, description, location, duration, price)
            VALUES (?, ?, ?, ?, ?, ?);
        """
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(insertStatement, 1, Int32(activity.destination_id))
            sqlite3_bind_text(insertStatement, 2, (activity.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (activity.description as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (activity.location as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 5, Int32(activity.duration) ?? 0)
            sqlite3_bind_double(insertStatement, 6, Double(activity.price) ?? 0.0)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully added activity.")
                fetchActivities()
            } else {
                print("ERROR: Could not insert activity.")
            }
        } else {
            print("ERROR: Could not prepare INSERT statement.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    func updateActivity(_ activity: Activity) {
        let updateStatementString = """
            UPDATE ACTIVITIES
            SET destination_id = ?, name = ?, description = ?, location = ?, duration = ?, price = ?
            WHERE id = ?;
        """
        var updateStatement: OpaquePointer?

        if sqlite3_prepare_v2(DatabaseManager.shared.db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStatement, 1, Int32(activity.destination_id))
            sqlite3_bind_text(updateStatement, 2, (activity.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 3, (activity.description as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 4, (activity.location as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 5, Int32(activity.duration) ?? 0)
            sqlite3_bind_double(updateStatement, 6, Double(activity.price) ?? 0.0)
            sqlite3_bind_int(updateStatement, 7, Int32(activity.activity_id))

            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated activity.")
                fetchActivities() // Refresh activity list
            } else {
                print("ERROR: Could not update activity.")
            }
        } else {
            print("ERROR: Could not prepare UPDATE statement.")
        }
        sqlite3_finalize(updateStatement)
    }

    func deleteActivity(_ activity: Activity) {
        let deleteStatementString = "DELETE FROM ACTIVITIES WHERE id = ?"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(activity.activity_id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted activity.")
                fetchActivities() // Refresh activity list
            } else {
                print("Could not delete activity.")
            }
        } else {
            print("ERROR: Could not prepare DELETE statement.")
        }
        
        sqlite3_finalize(deleteStatement)
    }
}

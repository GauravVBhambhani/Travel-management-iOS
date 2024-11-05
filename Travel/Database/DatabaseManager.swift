//
//  DatabaseManager.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/4/24.
//

import Foundation
import SQLite3

class DatabaseManager {
    
    static let shared = DatabaseManager()
    var db: OpaquePointer?
    
    
    private init() {
        openDatabase()
        createTable()
    }
    
    func openDatabase() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("tourism.db")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("ERROR: Couldn't open database")
        }
    }
    
    func createTable() {
        let createTableString = """
                CREATE TABLE IF NOT EXISTS USERS (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    firstName TEXT,
                    lastName TEXT,
                    phone INTEGER,
                    email TEXT,
                    password TEXT,
                    street TEXT,
                    city TEXT,
                    state TEXT,
                    pincode INTEGER
                );
                """
        
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("USERS table created!")
            } else {
                print("ERROR: USERS Table could not be created")
            }
        } else {
            print("ERROR: CREATE TABLE statement could not be prepared")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    
    
    func closeDatabase() {
        sqlite3_close(db)
    }
}

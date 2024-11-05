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
        createUserTable()
        createReviewTable()
        createBookingTable()
        createPaymentTable()
        createActivityTable()
        createItineraryTable()
        createTransportTable()
        createAccommodationTable()
        createTourGuideTable()
        createTravelAgencyTable()
        createGuideContractTable()
        createCustomerSupportTable()
        createTransportContractTable()
        createTouristDestinationTable()
        createAccommodationContractTable()
    }
    
    func openDatabase() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("tourism.db")
        
        print("open \(fileURL)")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("ERROR: Couldn't open database")
        }
    }
    
    func createUserTable() {
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
        
        executeStatement(createTableString, tableName: "USERS")
    }
    
    func createTourGuideTable() {
        let createTableString = """
            CREATE TABLE IF NOT EXISTS TOUR_GUIDES (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                firstName TEXT,
                lastName TEXT,
                contact INTEGER,
                language TEXT,
                yearsOfExperience INTEGER,
                rating INTEGER
            
            );
            """
        
        executeStatement(createTableString, tableName: "TOUR_GUIDES")
    }
    
    func createTouristDestinationTable() {
            let createTableString = """
                    CREATE TABLE IF NOT EXISTS TOURIST_DESTINATIONS (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        agency_id INTEGER,
                        name TEXT,
                        location TEXT,
                        popular_attractions TEXT,
                        rating INTEGER,
                        description TEXT,
                        FOREIGN KEY (agency_id) REFERENCES TRAVEL_AGENCY(id)
                    );
                    """
            
            executeStatement(createTableString, tableName: "TOURIST_DESTINATIONS")
        }
        
        func createActivityTable() {
            let createTableString = """
                    CREATE TABLE IF NOT EXISTS ACTIVITIES (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        destination_id INTEGER,
                        name TEXT,
                        description TEXT,
                        location TEXT,
                        duration TEXT,
                        price TEXT,
                        FOREIGN KEY (destination_id) REFERENCES TOURIST_DESTINATIONS(id)
                    );
                    """
            
            executeStatement(createTableString, tableName: "ACTIVITIES")
        }
        
        func createTransportTable() {
            let createTableString = """
                    CREATE TABLE IF NOT EXISTS TRANSPORT (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        type TEXT,
                        company_name TEXT,
                        departure_time TEXT,
                        arrival_time TEXT,
                        price FLOAT
                    );
                    """
            
            executeStatement(createTableString, tableName: "TRANSPORT")
        }
        
        func createAccommodationTable() {
            let createTableString = """
                    CREATE TABLE IF NOT EXISTS ACCOMMODATION (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        destination_id INTEGER,
                        name TEXT,
                        street TEXT,
                        city TEXT,
                        state TEXT,
                        zipcode INTEGER,
                        type TEXT,
                        price_per_night FLOAT,
                        availability_status TEXT,
                        rating INTEGER,
                        FOREIGN KEY (destination_id) REFERENCES TOURIST_DESTINATIONS(id)
                    );
                    """
            
            executeStatement(createTableString, tableName: "ACCOMMODATION")
        }
        
        func createReviewTable() {
            let createTableString = """
                    CREATE TABLE IF NOT EXISTS REVIEWS (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        user_id INTEGER,
                        destination_id INTEGER,
                        accommodation_id INTEGER,
                        activity_id INTEGER,
                        rating INTEGER,
                        review_text TEXT,
                        review_date DATETIME,
                        FOREIGN KEY (user_id) REFERENCES USERS(id),
                        FOREIGN KEY (destination_id) REFERENCES TOURIST_DESTINATIONS(id),
                        FOREIGN KEY (accommodation_id) REFERENCES ACCOMMODATION(id),
                        FOREIGN KEY (activity_id) REFERENCES ACTIVITIES(id)
                    );
                    """
            
            executeStatement(createTableString, tableName: "REVIEWS")
        }
        
        func createBookingTable() {
            let createTableString = """
                    CREATE TABLE IF NOT EXISTS BOOKINGS (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        item_id INTEGER,
                        user_id INTEGER,
                        booking_date DATETIME,
                        total_cost FLOAT,
                        payment_status TEXT,
                        FOREIGN KEY (user_id) REFERENCES USERS(id)
                    );
                    """
            
            executeStatement(createTableString, tableName: "BOOKINGS")
        }
        
        func createPaymentTable() {
            let createTableString = """
                    CREATE TABLE IF NOT EXISTS PAYMENTS (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        booking_id INTEGER,
                        payment_method TEXT,
                        payment_amount FLOAT,
                        payment_status TEXT,
                        transaction_date DATETIME,
                        FOREIGN KEY (booking_id) REFERENCES BOOKINGS(id)
                    );
                    """
            
            executeStatement(createTableString, tableName: "PAYMENTS")
        }
        
        func createItineraryTable() {
            let createTableString = """
                    CREATE TABLE IF NOT EXISTS ITINERARIES (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        user_id INTEGER,
                        start_date DATETIME,
                        end_date DATETIME,
                        destination TEXT,
                        total_cost FLOAT,
                        FOREIGN KEY (user_id) REFERENCES USERS(id)
                    );
                    """
            
            executeStatement(createTableString, tableName: "ITINERARIES")
        }
        
        func createCustomerSupportTable() {
            let createTableString = """
                    CREATE TABLE IF NOT EXISTS CUSTOMER_SUPPORT (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        user_id INTEGER,
                        issue_description TEXT,
                        resolution_status TEXT,
                        resolution_date DATETIME,
                        FOREIGN KEY (user_id) REFERENCES USERS(id)
                    );
                    """
            
            executeStatement(createTableString, tableName: "CUSTOMER_SUPPORT")
        }
        
        func createTravelAgencyTable() {
            let createTableString = """
                    CREATE TABLE IF NOT EXISTS TRAVEL_AGENCY (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        name TEXT,
                        location TEXT,
                        contact_info INTEGER,
                        rating INTEGER
                    );
                    """
            
            executeStatement(createTableString, tableName: "TRAVEL_AGENCY")
        }
        
        func createGuideContractTable() {
            let createTableString = """
                    CREATE TABLE IF NOT EXISTS GUIDE_CONTRACTS (
                        activity_id INTEGER,
                        guide_id INTEGER,
                        contract_start_date DATETIME,
                        contract_end_date DATETIME,
                        FOREIGN KEY (activity_id) REFERENCES ACTIVITIES(id),
                        FOREIGN KEY (guide_id) REFERENCES TOUR_GUIDES(id),
                        PRIMARY KEY (activity_id, guide_id)
                    );
                    """
            
            executeStatement(createTableString, tableName: "GUIDE_CONTRACTS")
        }
        
        func createAccommodationContractTable() {
            let createTableString = """
                    CREATE TABLE IF NOT EXISTS ACCOMMODATION_CONTRACTS (
                        agency_id INTEGER,
                        accommodation_id INTEGER,
                        contract_start_date DATETIME,
                        contract_end_date DATETIME,
                        FOREIGN KEY (agency_id) REFERENCES TRAVEL_AGENCY(id),
                        FOREIGN KEY (accommodation_id) REFERENCES ACCOMMODATION(id),
                        PRIMARY KEY (agency_id, accommodation_id)
                    );
                    """
            
            executeStatement(createTableString, tableName: "ACCOMMODATION_CONTRACTS")
        }
        
        func createTransportContractTable() {
            let createTableString = """
                    CREATE TABLE IF NOT EXISTS TRANSPORT_CONTRACTS (
                        agency_id INTEGER,
                        transport_id INTEGER,
                        contract_start_date DATETIME,
                        contract_end_date DATETIME,
                        FOREIGN KEY (agency_id) REFERENCES TRAVEL_AGENCY(id),
                        FOREIGN KEY (transport_id) REFERENCES TRANSPORT(id),
                        PRIMARY KEY (agency_id, transport_id)
                    );
                    """
            
            executeStatement(createTableString, tableName: "TRANSPORT_CONTRACTS")
        }
    
    private func executeStatement(_ createTableString: String, tableName: String) {
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("\(tableName) created!")
            } else {
                print("ERROR: \(tableName) Table could not be created")
            }
        } else {
            print("ERROR: CREATE TABLE statement for \(tableName) could not be prepared")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func closeDatabase() {
        sqlite3_close(db)
    }
}

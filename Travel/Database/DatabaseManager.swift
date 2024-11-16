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
        createScheduleTable()
        createAssetTable()
        createAssetContractTable()
        createBookingScheduleTable()
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
                    phone TEXT CHECK (LENGTH(phone) = 10),
                    email TEXT NOT NULL UNIQUE,
                    password TEXT NOT NULL,
                    street TEXT,
                    city TEXT,
                    state TEXT,
                    pincode TEXT CHECK (LENGTH(pincode) = 6)
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
                contact TEXT CHECK (LENGTH(contact) = 10),
                language TEXT,
                yearsOfExperience INTEGER CHECK (yearsOfExperience >= 0),
                rating INTEGER CHECK (rating BETWEEN 1 AND 5)
            );
            """
        
        executeStatement(createTableString, tableName: "TOUR_GUIDES")
    }
    
    func createTouristDestinationTable() {
        let createTableString = """
                    CREATE TABLE IF NOT EXISTS TOURIST_DESTINATION (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        agency_id INTEGER,
                        name TEXT,
                        location TEXT,
                        popular_attractions TEXT,
                        rating INTEGER CHECK (rating BETWEEN 1 AND 5),
                        description TEXT,
                        FOREIGN KEY (agency_id) REFERENCES TRAVEL_AGENCY(id)
                    );
                    """
        
        executeStatement(createTableString, tableName: "TOURIST_DESTINATION")
    }
    
    func createActivityTable() {
        let createTableString = """
                    CREATE TABLE IF NOT EXISTS ACTIVITIES (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        destination_id INTEGER,
                        name TEXT,
                        description TEXT,
                        location TEXT,
                        duration INTEGER CHECK (duration > 0),
                        price FLOAT CHECK (price >= 0),
                        FOREIGN KEY (destination_id) REFERENCES TOURIST_DESTINATION(id)
                    );
                    """
        
        executeStatement(createTableString, tableName: "ACTIVITIES")
    }
    
    func createTransportTable() {
        let createTableString = """
                    CREATE TABLE IF NOT EXISTS TRANSPORT (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        type TEXT NOT NULL,
                        company_name TEXT,
                        departure_time DATETIME,
                        arrival_time DATETIME,
                        price FLOAT CHECK (price >= 0)
                    );
                    """
        
        executeStatement(createTableString, tableName: "TRANSPORT")
    }
    
    func createAccommodationTable() {
        let createTableString = """
                    CREATE TABLE IF NOT EXISTS ACCOMMODATION (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        destination_id INTEGER,
                        name TEXT NOT NULL,
                        street TEXT,
                        city TEXT,
                        state TEXT,
                        zipcode TEXT,
                        type TEXT,
                        price_per_night FLOAT CHECK (price_per_night >= 0),
                        availability_status TEXT CHECK (availability_status IN ('Available', 'Booked')),
                        rating INTEGER CHECK (rating BETWEEN 1 AND 5),
                        FOREIGN KEY (destination_id) REFERENCES TOURIST_DESTINATION(id)
                    );
                    """
        
        executeStatement(createTableString, tableName: "ACCOMMODATION")
    }
    
    func createReviewTable() {
        let createTableString = """
                    CREATE TABLE IF NOT EXISTS REVIEWS (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        user_id INTEGER NOT NULL,
                        destination_id INTEGER NOT NULL,
                        accommodation_id INTEGER,
                        activity_id INTEGER,
                        rating INTEGER CHECK (rating BETWEEN 1 AND 5) NOT NULL,
                        review_text TEXT NOT NULL,
                        review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
                        FOREIGN KEY (user_id) REFERENCES USERS(id),
                        FOREIGN KEY (destination_id) REFERENCES TOURIST_DESTINATION(id),
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
                        itinerary_id INTEGER NOT NULL UNIQUE,
                        user_id INTEGER NOT NULL,
                        booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
                        total_cost FLOAT CHECK (total_cost >= 0),
                        payment_status TEXT CHECK (payment_status IN ('Paid', 'Pending', 'Canceled')),
                        accommodation_id INTEGER,
                        activity_id INTEGER,
                        schedule_id INTEGER,
                        FOREIGN KEY (user_id) REFERENCES USERS(id),
                        FOREIGN KEY (itinerary_id) REFERENCES ITINERARIES(id),
                        FOREIGN KEY (accommodation_id) REFERENCES ACCOMMODATION(id),
                        FOREIGN KEY (activity_id) REFERENCES ACTIVITIES(id),
                        FOREIGN KEY (schedule_id) REFERENCES SCHEDULE(id)
                    );
                    """
        
        executeStatement(createTableString, tableName: "BOOKINGS")
    }
    
    func createPaymentTable() {
        let createTableString = """
                    CREATE TABLE IF NOT EXISTS PAYMENTS (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        booking_id INTEGER,
                        payment_method TEXT CHECK (payment_method IN ('Credit Card', 'Debit Card', 'Cash')),
                        payment_amount FLOAT CHECK (payment_amount > 0),
                        payment_status TEXT CHECK (payment_status IN ('Paid', 'Pending', 'Failed')),
                        transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
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
                        total_cost FLOAT CHECK (total_cost >= 0),
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
                        issue_description TEXT NOT NULL,
                        resolution_status TEXT CHECK (resolution_status IN ('Resolved', 'Pending', 'Closed')),
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
                        name TEXT NOT NULL,
                        location TEXT,
                        contact_info TEXT CHECK (LENGTH(contact_info) = 10),
                        rating INTEGER CHECK (rating BETWEEN 1 AND 5)
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
                        PRIMARY KEY (activity_id, guide_id),
                        CHECK (contract_end_date >= contract_start_date)
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
                        PRIMARY KEY (agency_id, accommodation_id),
                        CHECK (contract_end_date >= contract_start_date)
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
                        PRIMARY KEY (agency_id, transport_id),
                        CHECK (contract_end_date >= contract_start_date)
                    );
                    """
        
        executeStatement(createTableString, tableName: "TRANSPORT_CONTRACTS")
    }
    
    func createScheduleTable() {
        let createTableString = """
                    CREATE TABLE IF NOT EXISTS SCHEDULE (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        asset_id INTEGER NOT NULL,
                        departure_time DATETIME NOT NULL,
                        arrival_time DATETIME NOT NULL,
                        price FLOAT CHECK (price >= 0),
                        FOREIGN KEY (asset_id) REFERENCES ASSET(id),
                        CHECK (arrival_time >= departure_time)
                    );
                    """
        
        executeStatement(createTableString, tableName: "SCHEDULE")
    }
    
    func createAssetTable() {
        let createTableString = """
                    CREATE TABLE IF NOT EXISTS ASSET (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        type TEXT NOT NULL,
                        company_name TEXT,
                        description TEXT,
                        value FLOAT CHECK (value >= 0)
                    );
                    """
        
        executeStatement(createTableString, tableName: "ASSET")
    }
    
    func createAssetContractTable() {
        let createTableString = """
                    CREATE TABLE IF NOT EXISTS ASSET_CONTRACTS (
                        agency_id INTEGER,
                        asset_id INTEGER,
                        contract_start_date DATETIME,
                        contract_end_date DATETIME,
                        FOREIGN KEY (agency_id) REFERENCES TRAVEL_AGENCY(id),
                        FOREIGN KEY (asset_id) REFERENCES ASSET(id),
                        PRIMARY KEY (agency_id, asset_id),
                        CHECK (contract_end_date >= contract_start_date)
                    );
                    """
        
        executeStatement(createTableString, tableName: "ASSET_CONTRACTS")
    }
    
    func createBookingScheduleTable() {
        let createTableString = """
                    CREATE TABLE IF NOT EXISTS BOOKING_SCHEDULE (
                        schedule_id INTEGER,
                        booking_id INTEGER,
                        start_date DATETIME,
                        end_date DATETIME,
                        FOREIGN KEY (schedule_id) REFERENCES SCHEDULE(id),
                        FOREIGN KEY (booking_id) REFERENCES BOOKINGS(id),
                        PRIMARY KEY (schedule_id, booking_id),
                        CHECK (end_date >= start_date)
                    );
                    """
        
        executeStatement(createTableString, tableName: "BOOKING_SCHEDULE")
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

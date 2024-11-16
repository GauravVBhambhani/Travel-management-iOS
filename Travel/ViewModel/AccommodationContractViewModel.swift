//
//  AccommodationContractViewModel.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import Foundation
import SQLite3

class AccommodationContractViewModel: ObservableObject {

    @Published var accommodationContracts = [AccommodationContract]()

    init() {
        fetchAccommodationContracts()
    }

    func fetchAccommodationContracts() {
        accommodationContracts.removeAll()

        let query = "SELECT * FROM ACCOMMODATION_CONTRACTS"
        var queryStatement: OpaquePointer?

        if sqlite3_prepare_v2(DatabaseManager.shared.db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let agency_id = sqlite3_column_int(queryStatement, 0)
                let accommodation_id = sqlite3_column_int(queryStatement, 1)
                let contractStartDateString = String(cString: sqlite3_column_text(queryStatement, 2))
                let contractEndDateString = String(cString: sqlite3_column_text(queryStatement, 3))

                let dateFormatter = ISO8601DateFormatter()
                let contractStartDate = dateFormatter.date(from: contractStartDateString) ?? Date()
                let contractEndDate = dateFormatter.date(from: contractEndDateString) ?? Date()

                let accommodationContract = AccommodationContract(
                    agency_id: Int(agency_id),
                    accommodation_id: Int(accommodation_id),
                    contractStartDate: contractStartDate,
                    contractEndDate: contractEndDate
                )

                accommodationContracts.append(accommodationContract)
            }
        } else {
            print("ERROR: Could not prepare SELECT statement.")
        }
        sqlite3_finalize(queryStatement)
    }

    func addAccommodationContract(_ accommodationContract: AccommodationContract) {
        let insertStatementString = """
            INSERT INTO ACCOMMODATION_CONTRACTS (agency_id, accommodation_id, contract_start_date, contract_end_date)
            VALUES (?, ?, ?, ?);
        """

        var insertStatement: OpaquePointer?

        if sqlite3_prepare_v2(DatabaseManager.shared.db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {

            sqlite3_bind_int(insertStatement, 1, Int32(accommodationContract.agency_id))
            sqlite3_bind_int(insertStatement, 2, Int32(accommodationContract.accommodation_id))

            let dateFormatter = ISO8601DateFormatter()
            let contractStartDate = dateFormatter.string(from: accommodationContract.contractStartDate)
            let contractEndDate = dateFormatter.string(from: accommodationContract.contractEndDate)

            sqlite3_bind_text(insertStatement, 3, (contractStartDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (contractEndDate as NSString).utf8String, -1, nil)

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully added accommodation contract.")
                fetchAccommodationContracts()
            } else {
                print("ERROR: Could not insert accommodation contract.")
            }
        } else {
            print("ERROR: Could not prepare INSERT statement.")
        }

        sqlite3_finalize(insertStatement)
    }

    func updateAccommodationContract(_ accommodationContract: AccommodationContract) {
        let updateStatementString = """
            UPDATE ACCOMMODATION_CONTRACTS
            SET contract_start_date = ?, contract_end_date = ?
            WHERE agency_id = ? AND accommodation_id = ?;
        """

        var updateStatement: OpaquePointer?

        if sqlite3_prepare_v2(DatabaseManager.shared.db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {

            let dateFormatter = ISO8601DateFormatter()
            let contractStartDate = dateFormatter.string(from: accommodationContract.contractStartDate)
            let contractEndDate = dateFormatter.string(from: accommodationContract.contractEndDate)

            sqlite3_bind_text(updateStatement, 1, (contractStartDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (contractEndDate as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 3, Int32(accommodationContract.agency_id))
            sqlite3_bind_int(updateStatement, 4, Int32(accommodationContract.accommodation_id))

            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated accommodation contract.")
                fetchAccommodationContracts() // Refresh accommodation contract list
            } else {
                print("ERROR: Could not update accommodation contract.")
            }
        } else {
            print("ERROR: Could not prepare UPDATE statement.")
        }

        sqlite3_finalize(updateStatement)
    }

    func deleteAccommodationContract(_ accommodationContract: AccommodationContract) {
        let deleteStatementString = "DELETE FROM ACCOMMODATION_CONTRACTS WHERE agency_id = ? AND accommodation_id = ?;"
        var deleteStatement: OpaquePointer?

        if sqlite3_prepare_v2(DatabaseManager.shared.db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(accommodationContract.agency_id))
            sqlite3_bind_int(deleteStatement, 2, Int32(accommodationContract.accommodation_id))

            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted accommodation contract.")
                fetchAccommodationContracts() // Refresh accommodation contract list
            } else {
                print("Could not delete accommodation contract.")
            }
        } else {
            print("ERROR: Could not prepare DELETE statement.")
        }

        sqlite3_finalize(deleteStatement)
    }
}

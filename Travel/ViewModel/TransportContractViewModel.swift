//
//  TransportContractViewModel.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import Foundation
import SQLite3

class TransportContractViewModel: ObservableObject {

    @Published var transportContracts = [TransportContract]()

    init() {
        fetchTransportContracts()
    }

    func fetchTransportContracts() {
        transportContracts.removeAll()

        let query = "SELECT * FROM TRANSPORT_CONTRACTS"
        var queryStatement: OpaquePointer?

        if sqlite3_prepare_v2(DatabaseManager.shared.db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let agency_id = sqlite3_column_int(queryStatement, 0)
                let transport_id = sqlite3_column_int(queryStatement, 1)
                let contractStartDateString = String(cString: sqlite3_column_text(queryStatement, 2))
                let contractEndDateString = String(cString: sqlite3_column_text(queryStatement, 3))

                let dateFormatter = ISO8601DateFormatter()
                let contractStartDate = dateFormatter.date(from: contractStartDateString) ?? Date()
                let contractEndDate = dateFormatter.date(from: contractEndDateString) ?? Date()

                let transportContract = TransportContract(
                    agency_id: Int(agency_id),
                    transport_id: Int(transport_id),
                    contractStartDate: contractStartDate,
                    contractEndDate: contractEndDate
                )

                transportContracts.append(transportContract)
            }
        } else {
            print("ERROR: Could not prepare SELECT statement.")
        }
        sqlite3_finalize(queryStatement)
    }

    func addTransportContract(_ transportContract: TransportContract) {
        let insertStatementString = """
            INSERT INTO TRANSPORT_CONTRACTS (agency_id, transport_id, contract_start_date, contract_end_date)
            VALUES (?, ?, ?, ?);
        """

        var insertStatement: OpaquePointer?

        if sqlite3_prepare_v2(DatabaseManager.shared.db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {

            sqlite3_bind_int(insertStatement, 1, Int32(transportContract.agency_id))
            sqlite3_bind_int(insertStatement, 2, Int32(transportContract.transport_id))

            let dateFormatter = ISO8601DateFormatter()
            let contractStartDate = dateFormatter.string(from: transportContract.contractStartDate)
            let contractEndDate = dateFormatter.string(from: transportContract.contractEndDate)

            sqlite3_bind_text(insertStatement, 3, (contractStartDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (contractEndDate as NSString).utf8String, -1, nil)

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully added transport contract.")
                fetchTransportContracts()
            } else {
                print("ERROR: Could not insert transport contract.")
            }
        } else {
            print("ERROR: Could not prepare INSERT statement.")
        }

        sqlite3_finalize(insertStatement)
    }

    func updateTransportContract(_ transportContract: TransportContract) {
        let updateStatementString = """
            UPDATE TRANSPORT_CONTRACTS
            SET contract_start_date = ?, contract_end_date = ?
            WHERE agency_id = ? AND transport_id = ?;
        """

        var updateStatement: OpaquePointer?

        if sqlite3_prepare_v2(DatabaseManager.shared.db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {

            let dateFormatter = ISO8601DateFormatter()
            let contractStartDate = dateFormatter.string(from: transportContract.contractStartDate)
            let contractEndDate = dateFormatter.string(from: transportContract.contractEndDate)

            sqlite3_bind_text(updateStatement, 1, (contractStartDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (contractEndDate as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 3, Int32(transportContract.agency_id))
            sqlite3_bind_int(updateStatement, 4, Int32(transportContract.transport_id))

            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated transport contract.")
                fetchTransportContracts() // Refresh transport contract list
            } else {
                print("ERROR: Could not update transport contract.")
            }
        } else {
            print("ERROR: Could not prepare UPDATE statement.")
        }

        sqlite3_finalize(updateStatement)
    }

    func deleteTransportContract(_ transportContract: TransportContract) {
        let deleteStatementString = "DELETE FROM TRANSPORT_CONTRACTS WHERE agency_id = ? AND transport_id = ?;"
        var deleteStatement: OpaquePointer?

        if sqlite3_prepare_v2(DatabaseManager.shared.db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(transportContract.agency_id))
            sqlite3_bind_int(deleteStatement, 2, Int32(transportContract.transport_id))

            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted transport contract.")
                fetchTransportContracts() // Refresh transport contract list
            } else {
                print("Could not delete transport contract.")
            }
        } else {
            print("ERROR: Could not prepare DELETE statement.")
        }

        sqlite3_finalize(deleteStatement)
    }
}

//
//  GuideContractViewModel.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import Foundation
import SQLite3

class GuideContractViewModel: ObservableObject {

    @Published var guideContracts = [GuideContract]()

    init() {
        fetchGuideContracts()
    }

    func fetchGuideContracts() {
        guideContracts.removeAll()

        let query = "SELECT * FROM GUIDE_CONTRACTS"
        var queryStatement: OpaquePointer?

        if sqlite3_prepare_v2(DatabaseManager.shared.db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let activity_id = sqlite3_column_int(queryStatement, 0)
                let guide_id = sqlite3_column_int(queryStatement, 1)
                let contractStartDateString = String(cString: sqlite3_column_text(queryStatement, 2))
                let contractEndDateString = String(cString: sqlite3_column_text(queryStatement, 3))

                let dateFormatter = ISO8601DateFormatter()
                let contractStartDate = dateFormatter.date(from: contractStartDateString) ?? Date()
                let contractEndDate = dateFormatter.date(from: contractEndDateString) ?? Date()

                let guideContract = GuideContract(
                    activity_id: Int(activity_id),
                    guide_id: Int(guide_id),
                    ContractStartDate: contractStartDate,
                    ContractEndDate: contractEndDate
                )

                guideContracts.append(guideContract)
            }
        } else {
            print("ERROR: Could not prepare SELECT statement.")
        }
        sqlite3_finalize(queryStatement)
    }

    func addGuideContract(_ guideContract: GuideContract) {
        let insertStatementString = """
            INSERT INTO GUIDE_CONTRACTS (activity_id, guide_id, contract_start_date, contract_end_date)
            VALUES (?, ?, ?, ?);
        """

        var insertStatement: OpaquePointer?

        if sqlite3_prepare_v2(DatabaseManager.shared.db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {

            sqlite3_bind_int(insertStatement, 1, Int32(guideContract.activity_id))
            sqlite3_bind_int(insertStatement, 2, Int32(guideContract.guide_id))

            let dateFormatter = ISO8601DateFormatter()
            let contractStartDate = dateFormatter.string(from: guideContract.ContractStartDate)
            let contractEndDate = dateFormatter.string(from: guideContract.ContractEndDate)

            sqlite3_bind_text(insertStatement, 3, (contractStartDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (contractEndDate as NSString).utf8String, -1, nil)

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully added guide contract.")
                fetchGuideContracts()
            } else {
                print("ERROR: Could not insert guide contract.")
            }
        } else {
            print("ERROR: Could not prepare INSERT statement.")
        }

        sqlite3_finalize(insertStatement)
    }

    func updateGuideContract(_ guideContract: GuideContract) {
        let updateStatementString = """
            UPDATE GUIDE_CONTRACTS
            SET contract_start_date = ?, contract_end_date = ?
            WHERE activity_id = ? AND guide_id = ?;
        """

        var updateStatement: OpaquePointer?

        if sqlite3_prepare_v2(DatabaseManager.shared.db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {

            let dateFormatter = ISO8601DateFormatter()
            let contractStartDate = dateFormatter.string(from: guideContract.ContractStartDate)
            let contractEndDate = dateFormatter.string(from: guideContract.ContractEndDate)

            sqlite3_bind_text(updateStatement, 1, (contractStartDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (contractEndDate as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 3, Int32(guideContract.activity_id))
            sqlite3_bind_int(updateStatement, 4, Int32(guideContract.guide_id))

            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated guide contract.")
                fetchGuideContracts() // Refresh guide contract list
            } else {
                print("ERROR: Could not update guide contract.")
            }
        } else {
            print("ERROR: Could not prepare UPDATE statement.")
        }

        sqlite3_finalize(updateStatement)
    }

    func deleteGuideContract(_ guideContract: GuideContract) {
        let deleteStatementString = "DELETE FROM GUIDE_CONTRACTS WHERE activity_id = ? AND guide_id = ?;"
        var deleteStatement: OpaquePointer?

        if sqlite3_prepare_v2(DatabaseManager.shared.db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(guideContract.activity_id))
            sqlite3_bind_int(deleteStatement, 2, Int32(guideContract.guide_id))

            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted guide contract.")
                fetchGuideContracts() // Refresh guide contract list
            } else {
                print("Could not delete guide contract.")
            }
        } else {
            print("ERROR: Could not prepare DELETE statement.")
        }

        sqlite3_finalize(deleteStatement)
    }
}

//
//  AssetContractViewModel.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import Foundation
import SQLite3

class AssetContractViewModel: ObservableObject {
    @Published var assetContracts = [AssetContract]()
    
    init() {
        fetchAssetContracts()
    }
    
    func fetchAssetContracts() {
        assetContracts.removeAll()
        
        let query = "SELECT * FROM ASSET_CONTRACTS"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let agencyId = sqlite3_column_int(queryStatement, 0)
                let assetId = sqlite3_column_int(queryStatement, 1)
                let contractStartDateString = String(cString: sqlite3_column_text(queryStatement, 2))
                let contractEndDateString = String(cString: sqlite3_column_text(queryStatement, 3))
                
                let dateFormatter = ISO8601DateFormatter()
                guard let contractStartDate = dateFormatter.date(from: contractStartDateString),
                      let contractEndDate = dateFormatter.date(from: contractEndDateString) else {
                    continue
                }
                
                let assetContract = AssetContract(
                    agency_id: Int(agencyId),
                    asset_id: Int(assetId),
                    contractStartDate: contractStartDate,
                    contractEndDate: contractEndDate
                )
                
                assetContracts.append(assetContract)
            }
        } else {
            print("ERROR: Could not prepare SELECT statement.")
        }
        sqlite3_finalize(queryStatement)
    }
    
    func addAssetContract(_ assetContract: AssetContract) {
        let insertStatementString = """
            INSERT INTO ASSET_CONTRACTS (agency_id, asset_id, contract_start_date, contract_end_date)
            VALUES (?, ?, ?, ?);
        """
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(assetContract.agency_id))
            sqlite3_bind_int(insertStatement, 2, Int32(assetContract.asset_id))
            
            let dateFormatter = ISO8601DateFormatter()
            let contractStartDateString = dateFormatter.string(from: assetContract.contractStartDate)
            let contractEndDateString = dateFormatter.string(from: assetContract.contractEndDate)
            
            sqlite3_bind_text(insertStatement, 3, (contractStartDateString as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (contractEndDateString as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully added asset contract.")
                fetchAssetContracts()
            } else {
                print("ERROR: Could not insert asset contract.")
            }
        } else {
            print("ERROR: Could not prepare INSERT statement.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    func deleteAssetContract(_ assetContract: AssetContract) {
        let deleteStatementString = "DELETE FROM ASSET_CONTRACTS WHERE agency_id = ? AND asset_id = ?"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(assetContract.agency_id))
            sqlite3_bind_int(deleteStatement, 2, Int32(assetContract.asset_id))
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted asset contract.")
                fetchAssetContracts()
            } else {
                print("Could not delete asset contract.")
            }
        } else {
            print("ERROR: Could not prepare DELETE statement.")
        }
        
        sqlite3_finalize(deleteStatement)
    }
}

//
//  AssetViewModel.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import Foundation
import SQLite3

class AssetViewModel: ObservableObject {
    
    @Published var assets = [Asset]()
    
    init() {
        fetchAssets()
    }
    
    func fetchAssets() {
        assets.removeAll()
        
        let query = "SELECT * FROM ASSET"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let type = String(cString: sqlite3_column_text(queryStatement, 1))
                let companyName = sqlite3_column_text(queryStatement, 2) != nil ? String(cString: sqlite3_column_text(queryStatement, 2)) : nil
                let description = sqlite3_column_text(queryStatement, 3) != nil ? String(cString: sqlite3_column_text(queryStatement, 3)) : nil
                let value = sqlite3_column_double(queryStatement, 4)
                
                let asset = Asset(
                    asset_id: Int(id),
                    type: type,
                    companyName: companyName,
                    description: description,
                    value: Float(value)
                )
                
                assets.append(asset)
            }
        } else {
            print("ERROR: Could not prepare SELECT statement.")
        }
        sqlite3_finalize(queryStatement)
    }
    
    func addAsset(_ asset: Asset) {
        let insertStatementString = """
            INSERT INTO ASSET (type, company_name, description, value)
            VALUES (?, ?, ?, ?);
        """
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(insertStatement, 1, (asset.type as NSString).utf8String, -1, nil)
            if let companyName = asset.companyName {
                sqlite3_bind_text(insertStatement, 2, (companyName as NSString).utf8String, -1, nil)
            } else {
                sqlite3_bind_null(insertStatement, 2)
            }
            if let description = asset.description {
                sqlite3_bind_text(insertStatement, 3, (description as NSString).utf8String, -1, nil)
            } else {
                sqlite3_bind_null(insertStatement, 3)
            }
            sqlite3_bind_double(insertStatement, 4, Double(asset.value))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully added asset.")
                fetchAssets()
            } else {
                print("ERROR: Could not insert asset.")
            }
        } else {
            print("ERROR: Could not prepare INSERT statement.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    func updateAsset(_ asset: Asset) {
        let updateStatementString = """
            UPDATE ASSET
            SET type = ?, company_name = ?, description = ?, value = ?
            WHERE id = ?;
        """
        var updateStatement: OpaquePointer?

        if sqlite3_prepare_v2(DatabaseManager.shared.db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (asset.type as NSString).utf8String, -1, nil)
            if let companyName = asset.companyName {
                sqlite3_bind_text(updateStatement, 2, (companyName as NSString).utf8String, -1, nil)
            } else {
                sqlite3_bind_null(updateStatement, 2)
            }
            if let description = asset.description {
                sqlite3_bind_text(updateStatement, 3, (description as NSString).utf8String, -1, nil)
            } else {
                sqlite3_bind_null(updateStatement, 3)
            }
            sqlite3_bind_double(updateStatement, 4, Double(asset.value))
            sqlite3_bind_int(updateStatement, 5, Int32(asset.asset_id))

            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated asset.")
                fetchAssets() // Refresh asset list
            } else {
                print("ERROR: Could not update asset.")
            }
        } else {
            print("ERROR: Could not prepare UPDATE statement.")
        }
        sqlite3_finalize(updateStatement)
    }

    func deleteAsset(_ asset: Asset) {
        let deleteStatementString = "DELETE FROM ASSET WHERE id = ?"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(asset.asset_id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted asset.")
                fetchAssets() // Refresh asset list
            } else {
                print("Could not delete asset.")
            }
        } else {
            print("ERROR: Could not prepare DELETE statement.")
        }
        
        sqlite3_finalize(deleteStatement)
    }
}

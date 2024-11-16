import Foundation
import SQLite3

class PaymentViewModel: ObservableObject {
    
    @Published var payments = [Payment]()
    
    init() {
        fetchPayments()
    }
    
    func fetchPayments() {
        payments.removeAll()
        
        let query = "SELECT * FROM PAYMENTS"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let booking_id = sqlite3_column_int(queryStatement, 1)
                guard let payment_method_string = sqlite3_column_text(queryStatement, 2) else {
                    continue
                }
                let payment_method = PaymentMethod(rawValue: String(cString: payment_method_string)) ?? .cash
                let payment_amount = sqlite3_column_double(queryStatement, 3)
                guard let payment_status_string = sqlite3_column_text(queryStatement, 4) else {
                    continue
                }
                let payment_status = PaymentStatus(rawValue: String(cString: payment_status_string)) ?? .pending
                guard let transaction_date_string = sqlite3_column_text(queryStatement, 5) else {
                    continue
                }
                
                let formatter = ISO8601DateFormatter()
                guard let transaction_date = formatter.date(from: String(cString: transaction_date_string)) else {
                    print("ERROR: Could not parse transaction date.")
                    continue
                }
                
                let payment = Payment(
                    payment_id: Int(id),
                    booking_id: Int(booking_id),
                    payment_method: payment_method,
                    payment_amount: Float(payment_amount),
                    payment_status: payment_status,
                    transaction_date: transaction_date
                )
                
                payments.append(payment)
            }
        } else {
            print("ERROR: Could not prepare SELECT statement.")
        }
        sqlite3_finalize(queryStatement)
    }
    
    func addPayment(_ payment: Payment) {
        let insertStatementString = """
            INSERT INTO PAYMENTS (booking_id, payment_method, payment_amount, payment_status, transaction_date)
            VALUES (?, ?, ?, ?, ?);
        """
        
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(insertStatement, 1, Int32(payment.booking_id))
            sqlite3_bind_text(insertStatement, 2, payment.payment_method.rawValue, -1, nil)
            sqlite3_bind_double(insertStatement, 3, Double(payment.payment_amount))
            sqlite3_bind_text(insertStatement, 4, payment.payment_status.rawValue, -1, nil)
            
            let formatter = ISO8601DateFormatter()
            let transactionDate = payment.transaction_date ?? Date()
            let transaction_date_string = formatter.string(from: transactionDate)
            sqlite3_bind_text(insertStatement, 5, transaction_date_string, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully added payment.")
                fetchPayments()
            } else {
                print("ERROR: Could not insert payment.")
            }
        } else {
            print("ERROR: Could not prepare INSERT statement.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    func updatePayment(_ payment: Payment) {
        let updateStatementString = """
            UPDATE PAYMENTS
            SET booking_id = ?, payment_method = ?, payment_amount = ?, payment_status = ?, transaction_date = ?
            WHERE id = ?;
        """
        var updateStatement: OpaquePointer?

        if sqlite3_prepare_v2(DatabaseManager.shared.db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStatement, 1, Int32(payment.booking_id))
            sqlite3_bind_text(updateStatement, 2, payment.payment_method.rawValue, -1, nil)
            sqlite3_bind_double(updateStatement, 3, Double(payment.payment_amount))
            sqlite3_bind_text(updateStatement, 4, payment.payment_status.rawValue, -1, nil)
            
            let formatter = ISO8601DateFormatter()
            let transactionDate = payment.transaction_date ?? Date()
            let transaction_date_string = formatter.string(from: transactionDate)
            sqlite3_bind_text(updateStatement, 5, transaction_date_string, -1, nil)
            
            sqlite3_bind_int(updateStatement, 6, Int32(payment.payment_id))

            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated payment.")
                fetchPayments() // Refresh payment list
            } else {
                print("ERROR: Could not update payment.")
            }
        } else {
            print("ERROR: Could not prepare UPDATE statement.")
        }
        sqlite3_finalize(updateStatement)
    }

    func deletePayment(_ payment: Payment) {
        let deleteStatementString = "DELETE FROM PAYMENTS WHERE id = ?"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(DatabaseManager.shared.db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(payment.payment_id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted payment.")
                fetchPayments() // Refresh payment list
            } else {
                print("Could not delete payment.")
            }
        } else {
            print("ERROR: Could not prepare DELETE statement.")
        }
        
        sqlite3_finalize(deleteStatement)
    }
}

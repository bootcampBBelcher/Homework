//// ============================================================
// EXERCISE: Structs — Value Types
// Estimated time: 20 minutes
//
// Structs in Swift are MUCH more powerful than in C.
// They can have methods, computed properties, and protocol conformance.
// The key rule: assignment COPIES a struct. Two variables never
// share the same struct instance.
// ============================================================

import Foundation

// TODO 3a: Define a struct named Transaction with these stored properties:
struct Transaction {
    var id: String
    var date: Date = Date()
    var amount: Double
    var description: String
    var isDebit: Bool
    //adding isPending as Bool
    var isPending: Bool = false
    
    //    // Add these computed properties:
    //    //   formattedAmount: String
    //    //     → returns "-$250.00" if isDebit, "+$250.00" if credit
    //    //     → use String(format: "%.2f", abs(amount))
    var formattedAmount: String {
        let sign = isDebit ? "-" : "+"
        let formattedValue = String(format: "%.2f", abs(amount))
        return "\(sign)$\(formattedValue)"
    }
    
    //    //   formattedDate: String
    //    //     -> use DateFormatter with dateStyle: .medium, timeStyle: .none
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
        
    // 3d: mutating method
    mutating func markAsPending() {
        isPending = true
    }
}
// TODO 3b: Create two Transaction instances:
//   t1: a credit of $2,500.00 described as "Direct Deposit"
//   t2: a debit of $45.67 described as "Starbucks"
let t1 = Transaction(id: "1001", date: Date(), amount: 2500.00, description: "Direct Deposit", isDebit: false)
var t2 = Transaction(id: "2002", date: Date(), amount: 45.67, description: "Starbucks", isDebit: true)
print("\(t1.description): \(t1.formattedAmount)")
print("\(t2.description): \(t2.formattedAmount)")

// TODO 3c: Prove value semantics
// Assign t1 to a new variable t3.
var t3 = t1
// Try to change t3.description to "Modified".
t3.description = "Modified"
// What happens? Why?
// Fix it by declaring t3 with var instead of let.
// Then change t3.description and print both t1.description and t3.description.
// Observe that t1 is unchanged. This is the key difference from classes.
print("t1 description: \(t1.description)") // Direct Deposit
print("t3 description: \(t3.description)") // Modified

// TODO 3d: Add a mutating method to Transaction named markAsPending
// that sets a new stored property isPending: Bool = false to true.
// Call it on t2 and verify.
t2.markAsPending()
print("t2 isPending: \(t2.isPending)")


// ============================================================
// EXERCISE: Classes — Reference Types
// Estimated time: 20 minutes
//
// Classes add: inheritance, reference semantics (assignment shares
// the same object), and deinitializers.
// Use classes for: managers, services, view controllers — things
// that have IDENTITY and LIFECYCLE, not just data.
// ============================================================

// TODO 4a: Define a class named BankAccount with:
//   Stored properties:
//     id: String
//     accountNumber: String
//     balance: Double
//     owner: String
class BankAccount {
    var id: String
    var accountNumber: String
    var balance: Double
    var owner: String

    init(id: String, accountNumber: String, owner: String, initialBalance: Double = 0.0) {
        self.id = id
        self.accountNumber = accountNumber
        self.owner = owner
        self.balance = initialBalance
    }

//   A designated initializer: init(id:accountNumber:owner:initialBalance:)
//   where initialBalance has a default of 0.0
//
//   Methods:
//     deposit(amount: Double) — adds to balance if amount > 0
//     withdraw(amount: Double) -> Bool — subtracts if amount > 0 and <= balance; returns success
//     printSummary() — prints "Account [accountNumber] | Owner: [owner] | Balance: $X.XX"

    func deposit(amount: Double) {
        if amount > 0 {
            balance += amount
        }
    }

    func withdraw(amount: Double) -> Bool {
        if amount > 0 && amount <= balance {
            balance -= amount
            return true
        }
        return false
    }
    func printSummary() {
        let formattedBalance = String(format: "%.2f", balance)
        Swift.print("Account \(accountNumber) | Owner: \(owner) | Balance: $\(formattedBalance)")
    }
}
// TODO 4b: Create two BankAccount instances:
//   checking: id "acc_001", accountNumber "1234567890", owner "Jane Smith", balance 1_000.00
//   savings:  id "acc_002", accountNumber "0987654321", owner "Jane Smith", balance 5_000.00

let checking = BankAccount(id: "acc_001", accountNumber: "1234567890", owner: "Jane Smith", initialBalance: 1_000.00)
let savings = BankAccount(id: "acc_002", accountNumber: "0987654321", owner: "Jane Smith", initialBalance: 5_000.00)
// Call deposit and withdraw on checking
checking.deposit(amount: 250.00)
let withdrawSuccess = checking.withdraw(amount: 100.00)
// Print summaries for both
checking.printSummary()
savings.printSummary()

// TODO 4c: Prove reference semantics
// Assign checking to a new variable checkingRef.
// Call checkingRef.deposit(amount: 500)
// Print checking.balance and checkingRef.balance.
// Observe they are THE SAME object — both show the updated balance.
// Write a comment explaining why this is different from the struct in 3c.
let checkingRef = checking
checkingRef.deposit(amount: 500.00)
print("checking balance: \(checking.balance)")       // Reflects the +500 deposit
print("checkingRef balance: \(checkingRef.balance)") // Identical value

// TODO 4d: Inheritance
// Define a class PremiumBankAccount that inherits from BankAccount.
// Add a stored property overdraftLimit: Double
// Override withdraw(amount:) so that withdrawal succeeds if
// amount <= balance + overdraftLimit (draws from overdraft if needed).
// Add a convenience initializer that takes the same params as BankAccount
// plus overdraftLimit.
//
// Test it: create a premium account with balance 100 and overdraftLimit 500.
// Withdraw 400 — should succeed (draws on overdraft).
// Withdraw 800 — should fail (exceeds balance + overdraftLimit).
class PremiumBankAccount : BankAccount {
    var overdraftLimit: Double = 0.0
    // Convenience initializer calling designated init
    convenience init(id: String, accountNumber: String, owner: String, initialBalance: Double = 0.0, overdraftLimit: Double) {
        self.init(id: id, accountNumber: accountNumber, owner: owner, initialBalance: initialBalance)
        self.overdraftLimit = overdraftLimit
    }

    // Override withdraw to support overdraft protection
    override func withdraw(amount: Double) -> Bool {
        if amount > 0 && amount <= (balance + overdraftLimit) {
            balance -= amount
            return true
        }
        return false
    }
}

// Test cases
let premium = PremiumBankAccount(id: "prem_001", accountNumber: "999888777", owner: "Jane Smith", initialBalance: 100.0, overdraftLimit: 500.0)

let test1 = premium.withdraw(amount: 400.0)
print("Withdraw $400 succeeded: \(test1)") // true (balance is now -300.0)
print("New balance: \(premium.balance)")

let test2 = premium.withdraw(amount: 800.0)
print("Withdraw $800 succeeded: \(test2)") // false (exceeds remaining available overdraft)
print("Final balance: \(premium.balance)")


// ============================================================
// EXERCISE: Enumerations
// Estimated time: 15 minutes
//
// Swift enums are the richest in any mainstream language.
// They can carry associated values — meaning each case can
// store different data. This replaces many patterns where
// Python/JS developers would use a dict or tuple.
// ============================================================

// TODO 5a: Define an enum TransactionType with cases:
//   credit, debit, transfer, fee
// Make it conform to String and CaseIterable:
//   enum TransactionType: String, CaseIterable
enum TransactionType: String, CaseIterable {
    case credit
    case debit
    case transfer
    case fee
// TODO 5b: Add a computed property displayName: String to TransactionType
// using a switch that returns:
//   credit   → "Credit"
//   debit    → "Debit"
//   transfer → "Transfer"
//   fee      → "Fee"
    var displayName: String {
        switch self {
        case .credit:
            return "Credit"
        case .debit:
            return "Debit"
        case .transfer:
            return "Transfer"
        case .fee:
            return "Fee"
        }
    }
}

// TODO 5c: Enum with associated values
// Define an enum AccountError with these cases:
//   insufficientFunds(available: Double, requested: Double)
//   accountInactive
//   dailyLimitExceeded(limit: Double)
//   invalidAmount
enum AccountError {
    case insufficientFunds(available: Double, requested: Double)
    case accountInactive
    case dailyLimitExceeded(limit: Double)
    case invalidAmount
}
// Write a function describeError(_ error: AccountError) -> String
// that uses a switch with associated value binding to return
// a user-friendly message for each case.
func describeError(_ error: AccountError) -> String {
    switch error {
    case .insufficientFunds(let available, let requested):
        let formattedAvail = String(format: "%.2f", available)
        let formattedReq = String(format: "%.2f", requested)
        return "Transaction failed: Insufficient funds. Available: $\(formattedAvail), Requested: $\(formattedReq)."
        
    case .accountInactive:
        return "Transaction failed: This account is currently inactive."
        
    case .dailyLimitExceeded(let limit):
        let formattedLimit = String(format: "%.2f", limit)
        return "Transaction failed: Daily withdrawal limit of $\(formattedLimit) exceeded."
        
    case .invalidAmount:
        return "Transaction failed: The specified amount is invalid."
    }
}
// Test it with all four cases.
let err1 = AccountError.insufficientFunds(available: 50.00, requested: 125.50)
let err2 = AccountError.accountInactive
let err3 = AccountError.dailyLimitExceeded(limit: 500.00)
let err4 = AccountError.invalidAmount

print(describeError(err1))
print(describeError(err2))
print(describeError(err3))
print(describeError(err4))
// TODO 5d: Iterate over all cases
// Using CaseIterable on TransactionType, print all transaction types
// and their raw values:
// for type in TransactionType.allCases { print(...) }
// Expected:
//   credit → "credit"
//   debit → "debit"
//   etc.
for type in TransactionType.allCases {
    print("\(type) → \"\(type.rawValue)\"")
}

// ============================================================
// MODULE 4: Swift Programming Fundamentals
// LAB — PNC Banking Domain Model
// Enterprise Mobile Application Development Bootcamp
// ============================================================
//
// OVERVIEW
// You are building the Swift data model layer for the PNC Mobile
// Banking application. This layer will be carried forward into
// Modules 6, 7, and 8 as the foundation of the real application.
//
// Every type you define here uses the Swift features from all
// three days of this module. Take time to read the full spec
// before writing any code.
//
// ESTIMATED TIME: 90–120 minutes
//
// ============================================================
// LAB SPEC
// ============================================================
//
// You will build five interconnected Swift types:
//
//   1. TransactionType enum
//   2. TransactionStatus enum
//   3. Transaction struct
//   4. Account class
//   5. AccountAnalytics struct


// And three protocols:
//
//   A. Summarizable       — any type that can produce a summary string
//   B. AccountOperations  — deposit, withdraw, transfer
//   C. AnalyticsProvider  — compute basic financial metrics
//
// The lab ends with an error handling system and a generic
// result reporting function that ties everything together.
//
// Read each section completely before implementing it.
// ============================================================

import Foundation


// ============================================================
// SECTION 1: Enumerations
// ============================================================

// TODO 1A: TransactionType
// Conform to: String, CaseIterable, Codable
// Cases:     credit, debit, transfer, fee
// Add computed property: isExpense: Bool
//   → true for .debit and .fee, false otherwise
enum TransactionType: String , CaseIterable, Codable{
    case credit = "Credit"
    case debit = "Debit"
    case transfer = "Transfer"
    case fee = "Fee"
    
    var isExpense : Bool {
        switch self{
        case .debit: return true
        case .fee: return true
        case .credit : return false
            case .transfer : return false}
    }
}
    // TODO 1B: TransactionStatus
    // Conform to: String, Codable
    // Cases:     pending, completed, failed, cancelled
    // Add computed property: isTerminal: Bool
    //   → true for .completed, .failed, .cancelled
    //   → false for .pending (can still change)
    enum TransactionStatus: String, Codable{
        case pending = "Pending"
        case completed = "Completed"
        case failed = "Failed"
        case cancelled = "Cancelled"
        
        var isTerminal: Bool {
            switch self {
            case .pending: return false
            case .completed: return true
            case .failed: return true
            case .cancelled: return true
            }
        }
    }
    
    // ============================================================
    // SECTION 2: Transaction Struct
    // ============================================================
    
    // TODO 2: Define struct Transaction conforming to:
    //   Identifiable, Codable, Equatable, Hashable, Summarizable (see Section 4A)
    struct Transaction: Identifiable,Codable, Equatable, Hashable, Summarizable {
        var id: String   = UUID().uuidString
        var date: Date
        var amount: Double          //  (always positive — type determines direction)
        var description: String
        var type: TransactionType
        var status: TransactionStatus = .completed
        var category: String?
        var merchantName: String?
        //
        // Computed properties:
        var formattedAmount: String {
            let absoluteAmount = abs(amount)
            let formattedNumber = String(format: "$%.2f", absoluteAmount)
            if type.isExpense {
                return   "-\(formattedNumber)"}
            else {
                return "+\(formattedNumber)"}
        }
        var formattedDate: String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        var resolvedCategory: String{
            category ?? "Uncategorized"
        }
        
        var summary: String {
                "\(description): \(formattedAmount)"
            }
        // Custom initializer (all params except id, status, category, merchantName
        // should be required; the rest should have defaults):
        //   init(date:amount:description:type:status:category:merchantName:)
        init(
            id: String = UUID().uuidString,
            date: Date,
            amount: Double,
            description: String,
            type: TransactionType,
            status: TransactionStatus = .completed,
            category: String? = nil,
            merchantName: String? = nil)
        {
            self.id = id
            self.date = date
            self.amount = amount
            self.description = description
            self.type = type
            self.status = status
            self.category = category
            self.merchantName = merchantName
        }
    }
    // ============================================================
    // SECTION 3: Account Class
    // ============================================================
    
    // TODO 3A: Define protocol AccountOperations (see Section 4B)
    // before defining Account, because Account will conform to it.
    // (Define the protocol in Section 4B, then add conformance to Account here)

    // TODO 3B: Define class BankAccount conforming to:
    //   Identifiable, AccountOperations, Summarizable
  
class BankAccount: Identifiable, AccountOperations, Summarizable {
    // Stored properties:
    var id: String
    var accountNumber: String
    var accountType: String       //   (e.g., "CHECKING", "SAVINGS")
    var nickname: String?
    var balance: Double
    var availableBalance: Double
    let currency: String = "USD"      //  (default "USD")
    let isActive: Bool = true       //   (default true)
    var transactions: [Transaction]
    //
    // Computed properties:
    
    var displayName: String {
        nickname ?? accountType.capitalized
    }
    var maskedAccountNumber: String{
        let lastFour = accountNumber.suffix(4)
        return "****\(lastFour)"
    }
    var formattedBalance: String{
        String(format: "$%.2f", balance)
    }
    var recentTransactions: [Transaction] {
        Array(transactions.sorted(by: { $0.date > $1.date}).prefix(5))
    }
    var pendingCount: Int {
        transactions.filter  { $0.status == .pending}.count
    }
    var summary: String {
            "\(displayName) (\(maskedAccountNumber)): \(formattedBalance)"
        }
    // Designated initializer:
    //   init(id:accountNumber:accountType:nickname:initialBalance:currency:isActive:)
    init(
            id: String = UUID().uuidString,
            accountNumber: String,
            accountType: String,
            nickname: String? = nil,
            balance: Double,
            availableBalance: Double,
            currency: String = "USD",
            isActive: Bool = true,
            transactions: [Transaction] = []
        ) {
            self.id = id
            self.accountNumber = accountNumber
            self.accountType = accountType
            self.nickname = nickname
            self.balance = balance
            self.availableBalance = availableBalance
            self.currency = currency
            self.isActive = isActive
            self.transactions = transactions
        }
    // Implement AccountOperations (see Section 4B for the protocol requirements).
    // AccountOperations Conformance
        func deposit(amount: Double) throws {
            guard isActive else { throw AccountOperationsError.accountInactive}
            guard amount > 0 else {throw AccountOperationsError.invalidAmount}
            
            balance += amount
            availableBalance += amount
        }
        
        func withdraw(amount: Double) throws {
            guard isActive else {throw AccountOperationsError.accountInactive}
            guard amount > 0 else {throw AccountOperationsError.invalidAmount}
            
            balance -= amount
            availableBalance -= amount
        }
    func transfer(amount: Double, to destination: BankAccount) throws {
        guard self.id != destination.id else { throw AccountOperationsError.transferToSameAccount}
        
        try withdraw(amount: amount)
        try destination.deposit(amount: amount)
    }
    
    // Use the AccountError enum from Section 4C.
    //
    // Also add:
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        if transaction.type.isExpense {
            balance -= transaction.amount
        } else {
            balance += transaction.amount
        }
        availableBalance = balance
    }
    
}
    // ============================================================
    // SECTION 4: Protocols
    // ============================================================
    
    // TODO 4A: Summarizable protocol
    //   Required: var summary: String { get }
    //   Default implementation via extension: func printSummary() — prints summary
    protocol Summarizable {
        var summary: String {get}
    }
extension Summarizable {
    func printSummary() {
        print(summary)
    }
}
    // TODO 4B: AccountOperations protocol
    //   func deposit(amount: Double) throws
    //   func withdraw(amount: Double) throws
    //   func transfer(amount: Double, to destination: BankAccount) throws
    protocol AccountOperations {
        func deposit(amount:Double) throws
        func withdraw(amount: Double) throws
        func transfer(amount:Double,to destination: BankAccount) throws
    }
    // These methods throw AccountOperationsError (define in Section 4C).
    
    
    // TODO 4C: AccountOperationsError enum conforming to LocalizedError
    // Cases:
    //   invalidAmount
    //   insufficientFunds(available: Double, required: Double)
    //   accountInactive
    //   transferToSameAccount
    //   dailyLimitExceeded(limit: Double)
    //
    // Each case should have a meaningful errorDescription.
enum AccountOperationsError: LocalizedError {
    case invalidAmount
    case insufficientFunds(available: Double, required: Double)
    case accountInactive
    case transferToSameAccount
    case dailyLimitExceeded(limit:Double)
    
    var errorDescription: String? {
        switch self {
        case .invalidAmount:
            return "Transaction amount must be greater than zero."
        case .insufficientFunds(let available, let required):
            return String (format:"Insufficient funds. Available: $%.2f, Required: $%.2f", available, required)
        case .accountInactive:
            return "Operation failed. This account is currently inactive."
        case .transferToSameAccount:
            return "Cannot transfer funds to the same account"
        case .dailyLimitExceeded(let limit):
            return String(format: "Transaction exceeds daily limit of $%.2f.", limit)
        }
    }
}
    
    // ============================================================
    // SECTION 5: Analytics
    // ============================================================
    
    // TODO 5A: AnalyticsProvider protocol
    protocol AnalyticsProvider {
        
        var totalCredits: Double { get }
        var totalDebits: Double { get }
        var netFlow: Double { get }         // credits - debits
        var largestTransaction: Transaction? { get }
        func monthlyTotal(month: Int, year: Int) -> Double
        func transactionsByCategory() -> [String: [Transaction]]
    }

// TODO 5B: AccountAnalytics struct
// Stored property: transactions: [Transaction]
// Conform to AnalyticsProvider.
// Implement each requirement.
struct AccountAnalytics: AnalyticsProvider {
    var transactions: [Transaction]
    
    var totalCredits: Double {
        transactions
            .filter { !$0.type.isExpense}
            .reduce(0.0) { $0 + $1.amount }
    }
    var totalDebits: Double {
        transactions
            .filter { !$0.type.isExpense}
            .reduce(0.0) { $0 + $1.amount }
    }
    var netFlow: Double {
        totalCredits - totalDebits}         // credits - debits
    var largestTransaction: Transaction? {
        transactions.max(by: {$0.amount < $1.amount})
    }
    func monthlyTotal(month: Int, year: Int) -> Double {
        let calander = Calendar.current
        return transactions
            .filter { transaction in
                let components = calander.dateComponents([.month, .year], from: transaction.date)
                return components.month == month && components.year == year && transaction.type.isExpense }
            .reduce(0.0) {$0 + $1.amount}
    }
    func transactionsByCategory() -> [String: [Transaction]] {
        Dictionary(grouping: transactions, by: {$0.resolvedCategory})
    }
}



// ============================================================
// SECTION 6: Generic Result Reporter
// ============================================================

// TODO 6: Write a generic function:
// ============================================================
// SECTION 6: Generic Result Reporter
// ============================================================

// TODO 6: Write a generic function:
func reportResults<T: Summarizable>(_ items: [T], title: String) {
    print("=== \(title) ===")
    print("[\(items.count)] items")
    for item in items {
        item.printSummary()
    }
    print("=== End of \(title) ===")
}
 
// It should:
//   1. Print a header line: "=== [title] ==="
//   2. Print the item count: "[N] items"
//   3. Call printSummary() on each item
//   4. Print a footer: "=== End of [title] ==="
//
// The function must work for any type conforming to Summarizable —
// including both Transaction and BankAccount.


// ============================================================
// SECTION 7: INTEGRATION TEST — Tie it all together
// ============================================================

// TODO 7: Write a function named runlabDemo() that does the following:
func runlabDemo(){
    // 7A: Create at least two BankAccount instances:
    //   - A checking account with $3,500 initial balance
    //   - A savings account with $12,000 initial balance
    let checkingAcct = BankAccount(accountNumber: "1234546", accountType: "CHECKING", nickname: "My checking", balance: 3500.00, availableBalance: 3500.00)
    let savingsAcct = BankAccount(accountNumber: "1234546", accountType: "SAVINGS", nickname: "Home Budget", balance: 1200.00, availableBalance: 1200.00)
    // 7B: Create at least five Transaction instances across different types
    //   and add them to the checking account using addTransaction(_:)
    //   Include: one credit, two debits, one fee, one transfer
   
    let depositCredit = Transaction(
        date: Date(),
        amount: 1500.0,
        description: "Direct Deposit - Salary",
        type: .credit,
        category: "Income"
    )
    let catDebit = Transaction(
        date: Date(),
        amount: 23.0,
        description: "Cat Food purchase",
        type: .debit,
        category: "expense"
    )
    let coffeeDebit = Transaction(
        date: Date(),
        amount: 12.0,
        description: "Starbucks",
        type: .debit,
        category: "expense"
    )
    let maintenanceFee = Transaction(
        date: Date(),
        amount: 5.0,
        description: "monthly service fee",
        type: .fee,
        category: "fee"
    )
    let transferOut = Transaction(
        date: Date(),
        amount: 200.0,
        description: "Transfer to other account",
        type: .transfer,
        category: "Transfer"
    )
    //   Verify the balance updates correctly after each addition.
    let initialTransactions = [depositCredit, catDebit, coffeeDebit, maintenanceFee, transferOut]

    print("Starting Balance: \(checkingAcct.formattedBalance)")

    for transaction in initialTransactions {
        let previousBalance = checkingAcct.balance
        checkingAcct.addTransaction(transaction)
        
        let change = transaction.type.isExpense ? "-\(transaction.amount)" : "+\(transaction.amount)"
        print("Added: \(transaction.description) (\(transaction.type.rawValue), \(change))")
        print("  Previous: $\(String(format: "%.2f", previousBalance)) ➔ New Balance: \(checkingAcct.formattedBalance)")
    }

    
    // 7C: Demonstrate error handling:
print("================")

    //   - Try to withdraw more than the available balance → catch insufficientFunds
    do {
        try checkingAcct.withdraw(amount: 1_000_000.00)
    } catch {
        print("Caught expected error \(error.localizedDescription)")
    }
    //   - Try to deposit a negative amount → catch invalidAmount
    do {
        try checkingAcct.deposit(amount: -200.00)
    }  catch {
        print("Caught expected error \(error.localizedDescription)")
    }
    //   - Try to transfer to the same account → catch transferToSameAccount
    do {
        try checkingAcct.transfer(amount: 100.00, to: checkingAcct)} catch {
            print("Caught expecteed error \(error.localizedDescription)")
        }

    //   Print the localized error description for each caught error.
    
    // 7D: Create an AccountAnalytics instance with the checking account's transactions.
    let analytics = AccountAnalytics(transactions: checkingAcct.transactions)
    
    print("Total Credits: $\(String(format: "%.2f", analytics.totalCredits))")
        print("Total Debits: $\(String(format: "%.2f", analytics.totalDebits))")
        print("Net Flow: $\(String(format: "%.2f", analytics.netFlow))")
        
        if let largest = analytics.largestTransaction {
            print("Largest Transaction: \(largest.description) (\(largest.formattedAmount))")
        }
        
        print("Transactions by Category:")
        let groupedCategories = analytics.transactionsByCategory()
        for (category, txs) in groupedCategories {
            print("  - \(category): \(txs.count) transaction(s)")
        }
    
    // 7E: Call reportResults with the checking account's transactions, title: "Checking Transactions"
    reportResults(checkingAcct.transactions, title: "Checking Transactions")
    //   Call reportResults with [checkingAccount, savingsAccount], title: "All Accounts"
    let accounts: [BankAccount] = [checkingAcct, savingsAcct]
    reportResults(accounts, title: "All Accounts")
    
    
    // 7F: Demonstrate value vs. reference semantics:
        // Copy one Transaction (struct) into a new variable. Modify the copy's description.
        var originalTx = catDebit
        var copiedTx = originalTx
        copiedTx.description = "Updated Pet Shop Purchase"
        
        // Show the original is unchanged.
        print("Original Tx Description: \(originalTx.description)")
        print("Copied Tx Description:   \(copiedTx.description)")
        print("Value Semantics Verified: Modifying the copied struct did not alter the original.\n")
        
        // Class (Reference Type) Copy:
        // Assign the checking account (class) to a new variable. Deposit $100 through the alias.
        let accountAlias = checkingAcct
        let balanceBeforeAliasDeposit = checkingAcct.balance
        
        do {
            try accountAlias.deposit(amount: 100.00)
        } catch {
            print("Deposit failed: \(error.localizedDescription)")
        }
        
        // Show both variables reflect the updated balance.
        print("Balance before alias deposit: $\(String(format: "%.2f", balanceBeforeAliasDeposit))")
        print("Balance via original variable: \(checkingAcct.formattedBalance)")
        print("Balance via alias variable:    \(accountAlias.formattedBalance)")
        print("Reference Semantics Verified: Both variables reference the same instance in memory.\n")
}

    // TODO: Call runlabDemo() at the bottom of the file.
    runlabDemo()


// ============================================================
// END OF LAB
// ============================================================
//
// SELF-ASSESSMENT CHECKLIST
// Before submitting, verify:
//   [ ] All five types compile without warnings
//   [ ] runlabDemo() runs to completion with no crashes
//   [ ] Each error case in 7C is handled and prints a clear message
//   [ ] Struct copy semantics are correctly demonstrated in 7F
//   [ ] Class reference semantics are correctly demonstrated in 7F
//   [ ] reportResults works for both Transaction and BankAccount
//   [ ] Analytics produce correct totals matching your transactions
// ============================================================

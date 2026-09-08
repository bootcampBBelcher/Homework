import Foundation


class Customer1 {
    
    let name: String
    var account: BankAccount1?
    
    init(name: String) {
        self.name = name
        self.account = nil
    }
    
    deinit {
        print("Customer \(name) is deallocating")
    }
    
}

class BankAccount1 {
    
    let number: String
    var owner: Customer1?
    
    init(number: String) {
        self.number = number
        self.owner = nil
    }
    
    deinit{
        print("Bank account \(number) is deallocating")
    }
    
}

// we want to create a scope (other than global) to contain instances
// of these classes, so the variables will go out of scope
// releasing their references
do {
    let cust = Customer1(name: "Arthur")
    let acct = BankAccount1(number: "001-234-5678")
    
    cust.account = acct
    acct.owner = cust
    
    
}

print("outside the block, objects should be deallocated")

let divider = "---------------"
print(divider)

print("Second Try:")

class Customer2 {
    
    let name: String
    var account: BankAccount2?
    
    init(name: String) {
        self.name = name
        self.account = nil
    }
    
    deinit {
        print("Customer \(name) is deallocating")
    }
    
    func proveReference () {
        print("Customer object has reference to account #\(account!.number)")
    }
    
}

class BankAccount2 {
    
    let number: String
    weak var owner: Customer2?
    
    init(number: String) {
        self.number = number
        self.owner = nil
    }
    
    deinit{
        print("Bank account \(number) is deallocating")
    }
   
    func proveReference() {
        print("Account object has reference to customer \(owner!.name)")
    }
}

// wrap objects in a do block to create a scope
// objects will go out fo scope once the block exits
do {
    let cust = Customer2(name: "Barbara")
    let acct = BankAccount2(number: "132452")
    
    cust.account = acct
    acct.owner = cust
          
          cust.proveReference()
          acct.proveReference()
}

print("outside the block, objects should be deallocated")


print(divider)
print("third try:")



class Customer3 {
    
    let name: String
    var account: BankAccount3?
    
    init(name: String) {
        self.name = name
        self.account = nil
    }
    
    deinit {
        print("Customer \(name) is deallocating")
    }
    
    func proveReference () {
        print("Customer object has reference to account #\(account!.number)")
    }
    
}

class BankAccount3 {
    
    let number: String
    unowned var owner: Customer3
    
    init(number: String, cust: Customer3) {
        self.number = number
        self.owner = cust
    }
    
    deinit{
        print("Bank account \(number) is deallocating")
    }
   
    func proveReference() {
        print("Account object has reference to customer \(owner.name)")
    }
}
//create a scope
do {
    let cust = Customer3(name: "Jill")
    let acct = BankAccount3(number: "38539853", cust:cust)
    
    cust.account = acct
    
    cust.proveReference()
    acct.proveReference()
    
}


print(divider)
print("Unwrapping Optionals: part-1: if-let")

var username: String?
username = "jsmith"

//first pattern for unwrapping optionals: if-let
// type of username is String? (or Optional <String> )
if let name = username {
    // type of name is String
    print("Hello, \(name)")
}

// name is not available here !!


// second pattern for unwrapping optionals: guard-let
// since guards need a scope to jump out of if their condition is not met
// create a do {} scope
// we can break out of do scope if the scope has a label
myScope: do{
    guard let name = username else {
        break myScope
    }
    
    // name is available. guard doesn't restrict scope like if let. no point of having nil value
    print("Hola, \(name)")
}


// third pattern for unwrapping optionals: nil coalescing operator
let name3 = username ?? "Guest"
print("Greetings, \(name3)")


username = nil
// fourth pattern: safe access operator
// it is useful fo raccessing either a property or method
// of some object that may be nil
let length = username?.count
let upper = username?.uppercased()
print(type(of: length))
print(type(of: upper))

if let name = username {
    let length = name.count
    let upper = name.uppercased()
    print(type(of:upper))
}


// the safe access operator is most museful when you want to invoke
// functionality of an object you may or may not have
// let repoistory: CUstomerRepository?

// repository?.saveData()


// fifth pattern: force unwrapping
// Danger: this pattern will throw an error if the value is nil
print("Hey there, \(username!)")

// use this pattern ONLY when a nil value is a programmer error
// that should crash during development

print(divider)

// create an error enumeration to embody all ways a monetary transfer can fail
enum TransferError: LocalizedError {
    case invalidAmount
    case insufficientFunds(available: Double)
    case dailyLimitExceeded(limit: Double, attempted: Double)
    case networkUnavailable
    
    var errorDescription: String? {
        switch self {
        case .invalidAmount:
            return "The amount must be greater than zero"
        case .insufficientFunds(available: let a):
            return "Insufficient funds. Available: $\(String(format: "%.2f", a))"
        case .dailyLimitExceeded(limit: let 1, attempted: let a):
            return "Daily transfer limit exceeded. Limit: $\(String(format: "%.2f",1)),
                    Attempted: $\String(format: "%.2f", a)) "
        case .networkUnavailable:
            return "Network unavailable. Please try again later"
        }
    }
}

//create a function that will try to perform the monetary transfer,
// throwing cases of this error enum appropriately
func executeTransfer(amount: Double, balance: Double) throws -> String {
    // make sure a positive amount was supplied
}














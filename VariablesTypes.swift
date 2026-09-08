//
//  VariablesTypes.swift
//  Lesson4
//
//  Created by user302134 on 8/31/26.
//

// this is a comment
// Swift is case-sensitive!

// create variables  using var
var message = "Hello"
print(message)

// create constants using let
let appName = "PNC Mobile"
// appName = "changed"


// declare variable, but don't assign a value
// we must declare its data type
// var counter: Int

var loginCounter = 0
// increment loginCounter
loginCounter += 1 // same as: loginCOunter = loginCounter + 1

// type inference
var balance = 4250.75

var rate: Double = 0.035

// type safety
let count: Int = 47
let total: Double = 12_309.88

// compute the average - cannont combine Int and Double
// need to convert the Int to Double
let avg = total / Double(count)


// conditionals - branching structures
if count > 10 {
    print("Count is large")
} else {
    print("Count is small")
}

// if condition1 {

// } else if condition2 {

//} else if condition3 {

// }

// safe conversion funnctions create Optionals (nilable)
let parsed = Int("2500")
let bad = Int("ABC")

print(type(of: bad))


// parsed contains Optional <Int> (or Int?)
// we need to "unwrap" the Int value from within Optional <Int>
// if combined with let creates a safe way of unwrapping Optionals:
// paresed is of typpe Optional <Int>
if let amount = parsed {
    // amount is of type Int
    // amount is scoped to the if block
    print("amount: \(amount)")
}
// amount is not visible here

if let _ = bad {
    print("ABC somewhow was considered to be an Int")
} else {
    print("You entered a non-numeric value")
}

// we also have "switch" as a descision structure
let transactionType = "transfer"

switch transactionType {
case "deposit":
    // some code here to do the depositing
    print("Deposit transaction")
case "withdraw":
    print("Withdraw transaction")
case "transfer":
    print("Transfer transaction")
default:
    print("Unknown transaction")
}

// switch can  use ranges of values
let myScore = 785
switch myScore {
case 800...850: //inclusive
    print("Excellent credit")
case 740...799:
    print("Very good credit")
case 670...739:
    print("Good credit")
case 580...669:
    print("Fair credit")
default:
    print("Poor credit")
}


// enumerations (enum) let us define a data type with a finite set of possible values
enum TransactionType {
    case deposit
    case withdrawal
    case fee
}

// Swift lets us use Implicit Memeber Expression
// aka leading dot syntax
var transactType: TransactionType = .withdrawal

// switch statements work very nicely with enumerations
switch transactType {
case .deposit:
    print("depositing")
case .withdrawal:
    print("withdrawing")
case .fee:
    print("charging a fee")
}


// clever variation on switch
// let salesTotal = 12_000

// switch true {
// case salesTotal > 10_000:
//     print("You earned the Gold Bonus!!")
//    // fallthrough   = keep going
// case salesTotal > 7_000:
//     print("You earned the Silver Bonus!!")
// default:
//     print("Try better next time")
// }



// enum cases can have data associated with them
// class like behavior added to cases
// enum cases can have different associated values for different cases
enum ServerResponse {
    case success(statusCode: Int, message: String)
    case failure(error: Error)
}

let response = ServerResponse.success(statusCode: 404, message: "Not Found")


// use a switch statement to process the response enum values
switch response {
case .success(statusCode: let code, message: let msg): //easier to pull out in case statement
    // we could use response.statusCode  ^
    print("Status code: \(code), Message: \(msg)")
// case let .success(statusCode: message):                               uses same names as enum
//     print("Status code: \(statusCode), Message: \(message)")
case .failure(error: let err):
    print("Error: \(err)")
}

// what if we want to handle different status codes very differently?
switch response {
case let .success(statusCode, message) where statusCode >= 200 && statusCode < 300:
    print("Success! Response: \(message)")
case let .success(statusCode, message) where statusCode >= 400:
    print("Warning: Server returned status \(statusCode) with message \(message)")
case let .success(statusCode, _):
    print("Received unexpexted success status code: \(statusCode)")
case .failure(error: let err):
    print("API error: \(err)")
}

// Swift allows for creation of tuples
// a tuple is a sequence of any number of values
// and each value could be any data type
let coordinates = (0,5)

// switch statements can work with tuples:
switch coordinates {
case (0,0):
    print("At the origin")
case (_,0):
    print("On the X axis")
case (0,_):
    print("On the Y axis")
default:
    print("Somewhere else in space")
}

// a Swift function
func sayHello() {
    print("Hello world!")
}

sayHello()


func greet(name:String){
    print("Hello \(name)!")
}

greet(name: "Blair")

// Pyramid of Doom:
func processPoorly(amount: Double?, balance: Double) {
    // only works if we have an amount
    if let amt = amount {
        // only will work if the amount is positive
        if amt > 0 {
            // only work if balance is sufficient
            if amt <= balance {
                // our work is buried 3 levels deep
                print("Executing transfer")
            } else {
                print("Insufficient funds")
            }
        } else {
            print("Invalid amount")
        }
            } else {
                print("No amount specificed")
            }
}

// eliminate pyramid of doom by using guard statements
func processWell(amount: Double?, balance: Double) {
        //only work if we have an amount
    guard let amt = amount else {
        print("No amount specified")
        return //exit function
    }
    // only work if the amount is positive
    guard amt > 0 else {
        print("Invalid amount")
        return
    }

    // only work if the balance is sufficient
    guard amt <= balance else {
        print("Insufficeint funds")
        return 
    }

    // work is not nested at all
    print("Executing the transfer")
}



let divider = "----------------------------"
print(divider)

// looping in swift
// we have basic "while" loop
var counter = 3

while counter > 0 {
    print("t-minus \(counter)")
    counter -= 1    // counter = counter - 1
}
print("Liftoff!!!")
print(divider)

// a while loopo might not exectue at all, the condition is false to begin with
// a variation is guarnteed to run at least once

var energy = 0

repeat {
    print("Working really hard")
    energy -= 1
} while energy > 0

print(divider)


// we also have for loop
// range 1...10 inclusive/closed range

for number in 1...3 {
    print("Number: \(number)")
}

print(divider)
// 1..<3 ; up to not including that number aka half open range
// cant do 1>..3
for number in 1..<3 {
    print("Number: \(number)")
}

print(divider)

// Swift array
// array = sequence of values
let fruits = ["Apple", "Banana", "Watermelon"]
for fruit in fruits {
    print(fruit)
}

print(divider)

// what if we want the index number along with the array element?
// Swift arrays have a enumerated() method
for (index,fruit) in fruits.enumerated() {
    print("\(fruit) occurs at index \(index)")
}

print(divider)

// you don't have to use the loop contant, but swift will still create it
// our loop will be slightly more efficient if we tell Swift NOT to create it
for _ in 1...3 {
    print("Hello")
}

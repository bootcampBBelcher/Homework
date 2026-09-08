
func transfer1(amount: Double, source: String, destination: String) {
    print("Transferring \(amount) from \(source) to \(destination)")
}

// by default, all parameters must be labeled,
// this make the invocation (call site) read like English
transfer1(amount: 1000, source: "Checking", destination: "Savings")


//optionally, we can use a different parameter name externally (when calling the function)
// than we use interally (in the code of the function)
func transfer2(amount: Double, from source: String, to destination: String) { // external first and internal second
    print("Transfering $\(amount) from \(source) to \(destination)")
}

transfer2(amount: 1000, from: "Checking", to: "Savings")


func transfer3(_ amount: Double, from source: String, to destination: String){
    print("Transfering $\(amount) from \(source) to \(destination)")
}

transfer3(1000, from: "Checking", to: "Savings")


func authenticate(_ username: String, with password: String){
    print("Authenticating user: \(username), with password \(password)")
}


authenticate("alice", with: "secret")

let divider = "--------------------------------------------------"
print(divider)


func loadRecords1(limit: Int = 50, offset: Int = 0) {
    print("Loading \(limit) recrods starting at index \(offset)")
}

loadRecords1()  // limit: 50, offset: 0
loadRecords1(limit: 20) // limit: 20, offset: 0
loadRecords1(limit:20, offset: 40)  // cant provide in wrong order
loadRecords1(offset: 150)

print(divider)

// functions can return values
func makeGreeting(name: String) -> String {
    return "Hello \(name)"
}

print(makeGreeting(name: "Justine"))
print(makeGreeting(name:"Julio"))


print(divider)

// return a bunch of data
func loadRecords2(limit: Int = 50, offset: Int = 0) -> [String] {
    var result: [String] = []

    for num in offset..<(offset + limit){
        result.append("Record from index \(num)")
    }

    return result
}

print(loadRecords2(limit:5, offset: 8))


print(divider)

// suppose we want to return multiple values from a function
// but they are different data types
// a typed tuple may be the best option
func validate(_ amount: Double) -> (isValid: Bool, error: String?){
    guard amount > 0 else {
        return (false, "Must be > 0")
    }

    return(true, nil)
}

let r = validate(500)

if r.isValid{
    print("proceeding with the calculation")
} else {
    print(r.error!) // ! is force unwrapping. usually looked down upon
}

print(divider)



// CLOSURE
// from one point of view, a closure is a short-hand syntax for a function

// ful syntax:
let multiply1 = { (a: Int, b: Int) -> Int in return a * b }

print(multiply1(4, 5))  //when invoking a closure, it does NOT want parameter labels


// syntax variation 1:
// the data types can be specified on the constant
let multiply2: (Int,Int) -> Int = {a,b in return a * b}
print(multiply2(4,5))


// syntax variation 2:
// the "return" keyword is implied
let multiply3: (Int, Int) -> Int = { a, b in a * b }
print(multiply3(4,5))

print(divider)



// closure capture constants and variables from their surronding context
// (and this is by refernce, so changes will persist)
func makeCounter() -> () -> Int {
    var current = 0
    let myClosure: () -> Int = {
        current += 1
        return current
    }
    return myClosure   
}

let next = makeCounter()
let otherCounter = makeCounter()

print(next())
print(next())
print(next())

print(otherCounter())

print(next())

print(divider)


// one of the major uses of closures is to use them as parameters to other functions
// this is common when we have a general algorithm that is frequently used,
// but each time it is used, one or more details will be different
// so we write one function that implements the basic algorithm,
// and have that function receive another function as its parameter,
//to allow the behavioral variatons to be passed in

let balances = [3_250.00, 12_000.00, 450.75, 8_900.00, 125.50, 22_450.00]

// suppose we want to print out each of our balances
for bal in balances{
    print("The current balance is $\(bal)")
}
print(divider)

// we can do the same task by passing in a fuction (closure) to the array forEach() method
balances.forEach({ (bal: Double) in print("The current balance is $\(bal)") } )it 
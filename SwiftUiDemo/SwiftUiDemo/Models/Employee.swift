//
//  Employee.swift
//  SwiftUiDemo
//
//  Created by user302134 on 9/8/26.
//

import SwiftUI

@Observable
class Employee {
    
    var id: Int
    var firstName: String
    var lastName: String
    
    init(id: Int, firstName: String, lastName: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
    
}






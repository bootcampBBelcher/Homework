//
//  ProductLIst.swift
//  SwiftUiDemo
//
//  Created by user302134 on 9/8/26.
//
import SwiftUI

struct ProductList: View {
    @State private var products: [Product] = []
    
    var body: some View {
        NavigationStack{
            List(products) { prd in
                NavigationLink(prd.displayName, value: prd )
            }
            .navigationTitle("Products")
            .navigationDestination(for: Product.self){
                selectedItem in
                ProductDetails(products: selectedItem)
            }
            
        }
        .task{
            loadData()
        }
        
    }
    
    func loadData(){
        products = [
            Product(id: 101, name: "Antonio", productNumber: "abc123", color: "blue", listPrice: 25.50),
            Product(id: 102, name: "Garcia", productNumber: "abc456", color: "green", listPrice: 28.63),
            Product(id: 103, name: "Spencer", productNumber: "abc789", color: "purple", listPrice: 39.24),
        ]
    }
}

#Preview {
    ProductList()
}


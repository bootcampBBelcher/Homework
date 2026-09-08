//
//  ProductDetails.swift
//  SwiftUiDemo
//
//  Created by user302134 on 9/8/26.
//

import SwiftUI

struct ProductDetails: View {
    
    var products: Product
    
    var body: some View {
            @Bindable var prdBinding = products
        
        
        VStack {
            Text("Product ID #\(products.id)")
                .font(.largeTitle)
                .fontWeight(.bold)
    
                TextField("Product Name", text: $prdBinding.name)
                    .font(Font.title)
                    .textFieldStyle(.roundedBorder)
                    .padding(20)
                TextField("Product Number", text: $prdBinding.productNumber)
                    .font(Font.title)
                    .textFieldStyle(.roundedBorder)
                    .padding(20)
                TextField("Color", text: $prdBinding.color)
                    .font(Font.title)
                    .textFieldStyle(.roundedBorder)
                    .padding(20)
            TextField("List Price",value: $prdBinding.listPrice, format: .number)
                    .font(Font.title)
                    .textFieldStyle(.roundedBorder)
                    .padding(20)
          
//            var id: Int
//            var name: String
//            var productNumber: String
//            var color: String
//            var listPrice: Double
        }
        .padding()
      
    }
}

#Preview {
   ProductDetails(products: Product(id: 101, name: "Antonio", productNumber: "abc123", color: "blue", listPrice: 25.50))
}



//
//  ProductsView.swift
//  TSL SDK
//
//  Created by Mayuri on 2024-08-13.
//

import Foundation
import SwiftUI

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let price: String
    let description: String
    let imageName: String
}

struct ProductsView: View {
    
    let width = UIScreen.main.bounds.width / 3
    
    let products: [Product] = [
        Product(name: "Product 1", price: "$19.99", description: "This is an amazing product.", imageName: "https://cdn-dev.talkshop.live/eyJidWNrZXQiOiJ0c2wtaW1hZ2VzLWRldmVsb3BtZW50Iiwia2V5IjoidmFyaWFudF9pbWFnZXMvMTQ4ODkvb3JpZ2luYWwvd2lkZ2V0LmpwZyIsImVkaXRzIjp7InJlc2l6ZSI6eyJ3aWR0aCI6MjEzMywiZml0IjoiY29udGFpbiJ9fX0="),
        Product(name: "Product 2", price: "$29.99", description: "This is another amazing product.", imageName: "https://cdn-dev.talkshop.live/eyJidWNrZXQiOiJ0c2wtaW1hZ2VzLWRldmVsb3BtZW50Iiwia2V5IjoidmFyaWFudF9pbWFnZXMvMTQ4ODkvb3JpZ2luYWwvd2lkZ2V0LmpwZyIsImVkaXRzIjp7InJlc2l6ZSI6eyJ3aWR0aCI6MjEzMywiZml0IjoiY29udGFpbiJ9fX0="),
        Product(name: "Product 3", price: "$39.99", description: "A fantastic product with great features.", imageName: "https://cdn-dev.talkshop.live/eyJidWNrZXQiOiJ0c2wtaW1hZ2VzLWRldmVsb3BtZW50Iiwia2V5IjoidmFyaWFudF9pbWFnZXMvMTQ4ODkvb3JpZ2luYWwvd2lkZ2V0LmpwZyIsImVkaXRzIjp7InJlc2l6ZSI6eyJ3aWR0aCI6MjEzMywiZml0IjoiY29udGFpbiJ9fX0="),
        Product(name: "Product 4", price: "$49.99", description: "This product is the best in its category.", imageName: "https://cdn-dev.talkshop.live/eyJidWNrZXQiOiJ0c2wtaW1hZ2VzLWRldmVsb3BtZW50Iiwia2V5IjoidmFyaWFudF9pbWFnZXMvMTQ4ODkvb3JpZ2luYWwvd2lkZ2V0LmpwZyIsImVkaXRzIjp7InJlc2l6ZSI6eyJ3aWR0aCI6MjEzMywiZml0IjoiY29udGFpbiJ9fX0="),
        // Add more products here
    ]
    
    var body: some View {
        List(products) { product in
            HStack(alignment: .top, spacing: 10) {
                
                AsyncImage(url: URL(string: product.imageName)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: width)
                            .background(Color.gray.opacity(0.2)) // Placeholder color
                            
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: width)
                            .cornerRadius(8)
                            
                    case .failure:
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.red)
                            .frame(width: width)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(product.name)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text(product.price)
                        .font(.subheadline)
                        .foregroundColor(.green)
                    
                    Text(product.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
            }
            .padding(.vertical, 5)
        }
        .navigationTitle("Products")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView()
    }
}

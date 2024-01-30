//
//  ContentView.swift
//  TSL SDK
//
//  Created by Daman Mehta on 2024-01-22.
//
import SwiftUI
import tsl_ios_sdk

struct ContentView: View {
    @State private var idInput: String = ""
    @State private var apiResult: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter ID", text: $idInput)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onAppear {
                        // Set the initial value for idInput
                        idInput = "vzzg6tNu0qOv"
                }
            
            Button("Fetch Data") {
                fetchShowData()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
            
            Text(apiResult)
                .padding()
        }
        .padding()
    }
    
    func fetchShowData() {
        // Replace the API URL with your actual API endpoint
        self.apiResult = idInput
        let tslSDK = TSLSDK.shared
        var showDetails : TSLShow?
        tslSDK.getShows(productKey: "vzzg6tNu0qOv") { result in
            switch result {
                case .success(let show):
                    showDetails = show
                    // Access properties of TSLShow directly
                self.apiResult = showDetails?.name ?? ""
                case .failure(let error):
                    // Handle error case
                    print("Error: \(error.localizedDescription)")
                }
        }

    }
}

struct YourDecodableModel: Decodable {
    // Define your model properties based on the API response
    let property: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

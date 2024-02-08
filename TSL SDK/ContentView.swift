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
    @State private var showResult: String = ""
    
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
            
            Text(showResult)
                .padding()
        }
        .padding()
    }
    
    func fetchShowData() {
        // Replace the API URL with your actual API endpoint
        self.showResult = idInput
        let showInstance = tsl_ios_sdk.Show()
        let showId = "vzzg6tNu0qOv"
        showInstance.getDetails(showId: showId) { result in
            switch result {
            case .success(let show):
                // Access properties of TSLShow directly
                self.showResult = show.name ?? ""
            case .failure(let error):
                // Handle error case
                self.showResult = "Error: \(error.localizedDescription)"
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

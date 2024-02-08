//
//  ContentView.swift
//  TSL SDK
//
//  Created by Daman Mehta on 2024-01-22.
//
import SwiftUI
import tsl_ios_sdk

struct ContentView: View {
    @State private var showInput: String = ""
    @State private var showResult: String = ""
    @State private var eventResult: String = ""
    @State private var eventInput: String = ""
    
    var showID = "vzzg6tNu0qOv"
    var eventID = "8WtAFFgRO1K0"

    var body: some View {
        VStack {
            TextField("Enter ID", text: $showInput)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onAppear {
                    // Set the initial value for idInput
                    showInput = showID
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
        
        VStack {
            TextField("Enter Event ID", text: $eventInput)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onAppear {
                        // Set the initial value for idInput
                        eventInput = eventID
                }
            
            Button("Fetch Event Data") {
                fetchCurrentEvent()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
            
            Text(eventResult)
                .padding()
        }
        .padding()
    }
    
    func fetchShowData() {
        // Replace the API URL with your actual API endpoint
        self.showResult = showInput
        let showInstance = tsl_ios_sdk.Show()
        showInstance.getDetails(showId: self.showID) { result in
            switch result {
            case .success(let show):
                // Access properties of TSLShow directly
                self.showResult = "Show Name: " + (show.name ?? "")
            case .failure(let error):
                // Handle error case
                self.showResult = "Error: \(error.localizedDescription)"
            }
        }
    }
    
    func fetchCurrentEvent() {
        // Replace the API URL with your actual API endpoint
        self.eventResult = eventInput
        let showInstance = tsl_ios_sdk.Show()
        let showId = eventID
        showInstance.getStatus(showId: showId) { result in
            switch result {
                case .success(let show):
                    // Access properties of TSLShow directly
                self.eventResult = "Event Name: " + (show.name ?? "")
                case .failure(let error):
                    // Handle error case
                self.eventResult = "Error: \(error.localizedDescription)"

                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

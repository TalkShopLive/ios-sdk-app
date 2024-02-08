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
    @State private var showObject : tsl_ios_sdk.ShowData? = nil
    
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
            
            Button("Fetch Shows") {
                fetchShowData()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
            
            Button("Fetch Current Event") {
                fetchCurrentEvent()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
            
            Button("Get Closed Captions Using ShowID") {
                fetchClosedCaptionsUsingShowId()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
            
            Button("Get Closed Captions Using EventID") {
                fetchClosedCaptionsUsingEventId()
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
        self.showResult = showInput
        let showInstance = tsl_ios_sdk.Show()
        showInstance.getDetails(showId: self.showID) { result in
            switch result {
            case .success(let show):
                // Access properties of TSLShow directly
                self.showObject = show
                self.showResult = "Show Name: " + (show.name ?? "")
            case .failure(let error):
                // Handle error case
                self.showResult = "Error: \(error.localizedDescription)"
            }
        }
    }
    
    func fetchCurrentEvent() {
        // Replace the API URL with your actual API endpoint
        self.showResult = eventInput
        self.showInput = eventID
        let showInstance = tsl_ios_sdk.Show()
        let showId = eventID
        showInstance.getStatus(showId: showId) { result in
            switch result {
                case .success(let show):
                    // Access properties of TSLShow directly
                self.showResult = "Event Name: " + (show.name ?? "")
                case .failure(let error):
                    // Handle error case
                self.showResult = "Error: \(error.localizedDescription)"

                }
        }
    }
    
    func fetchClosedCaptionsUsingEventId() {
        // Replace the API URL with your actual API endpoint
        let showInstance = tsl_ios_sdk.Show()
        
        showInstance.getClosedCaptions(eventId: self.showObject?.currentEvent?.id) { result in
            switch result {
            case .success(let fileName):
                // Access properties of TSLShow directly
                self.showResult = fileName
            case .failure(let error):
                // Handle error case
                self.showResult = "Error: \(error.localizedDescription)"
            }
        }
    }
    
    func fetchClosedCaptionsUsingShowId() {
        // Replace the API URL with your actual API endpoint
        self.showResult = showID
        let showInstance = tsl_ios_sdk.Show.shared
        
        showInstance.getClosedCaptions(showId: self.showObject?.productKey) { result in
            switch result {
            case .success(let fileName):
                // Access properties of TSLShow directly
                self.showResult = fileName
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

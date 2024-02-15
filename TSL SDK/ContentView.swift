//
//  ContentView.swift
//  TSL SDK
//
//  Created by Daman Mehta on 2024-01-22.
//
import SwiftUI
import TalkShopLive

struct ContentView: View {
    @State private var showInput: String = ""
    @State private var showResult: String = ""
    @State private var eventResult: String = ""
    @State private var eventInput: String = ""
    @State private var showObject : TalkShopLive.ShowData? = nil
    
    var showID = "vzzg6tNu0qOv"
    var eventID = "8WtAFFgRO1K0"
    
    
    var body: some View {
        VStack {
            
            Button("Initialize SDK") {
                initializeSDK()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
            
            
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
            
            Button("Fetch Closed Captions") {
                fetchClosedCaptions()
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
    
    func initializeSDK() {
        // Replace the API URL with your actual API endpoint
        let TSL = TalkShopLive.Authenticate(clientKey: "0GmN76SBDdHRsGLRDcmVzpURj",debugMode: true,testMode: true)
        print(TSL)
    }
    
    func fetchShowData() {
        // Replace the API URL with your actual API endpoint
        self.showResult = showInput
        let showInstance = TalkShopLive.Show()
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
        let showInstance = TalkShopLive.Show()
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
    
    func fetchClosedCaptions() {
        self.showResult = "File Name: \n\n" + (self.showObject?.cc ?? "Closed captions file not available")
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

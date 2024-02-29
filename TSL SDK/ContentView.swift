//
//  ContentView.swift
//  TSL SDK
//
//  Created by Daman Mehta on 2024-01-22.
//
import SwiftUI
import Talkshoplive

struct ContentView: View {
    @State private var showInput: String = ""
    @State private var showResult: String = ""
    @State private var eventResult: String = ""
    @State private var eventInput: String = ""
    @State private var showObject : Talkshoplive.ShowData? = nil
    
    var showID = "vzzg6tNu0qOv"
    var eventID = "8WtAFFgRO1K0"
    @State private var chat: Talkshoplive.Chat? = nil

    
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
            
            Button("Create Messaging Token - Guest") {
                createTokenGuestUser()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
            
            Button(action: {
                createTokenFedaratedUser()
            }) {
                Text("Create Messaging Token - Fedarated User")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            Button(action: {
                sendMessage()
            }) {
                Text("Send Message")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            Text(showResult)
                .padding()
        }
        .padding()
        
    }
    
    func initializeSDK() {
        // Replace the API URL with your actual API endpoint
        let TSL = Talkshoplive.TalkShopLive(clientKey: "sdk_2ea21de19cc8bc5e8640c7b227fef2f3",debugMode: true,testMode: true)
        print(TSL)
    }
    
    func fetchShowData() {
        // Replace the API URL with your actual API endpoint
        self.showResult = showInput
        let showInstance = Talkshoplive.Show()
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
        let showInstance = Talkshoplive.Show()
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
    
    func createTokenGuestUser() {
        let token = "eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJzZGtfMmVhMjFkZTE5Y2M4YmM1ZTg2NDBjN2IyMjdmZWYyZjMiLCJleHAiOjE3MDkyNjc3NDYsImp0aSI6InRXaEJBd1NUbVhVNnp5UUsxNUV1eXk9PSJ9.hHFWaQU-8yMCnPTsI7ah5wapjLvwSwo2ZbuQNwPggfU"
        /*
         Payload to generate JWT Token for Guest User :
         {
           "iss": "sdk_2ea21de19cc8bc5e8640c7b227fef2f3", //SDK Key
           "exp": 1709267746, // Timeinterval from now to 1 day
           "jti": "tWhBAwSTmXU6zyQK15Euyy==", // Unique Random string
         }
         */
        self.chat = Talkshoplive.Chat(jwtToken: token, isGuest:true, showKey: "8WtAFFgRO1K0", mode: "public", refresh: "manual")
    }
    
    func createTokenFedaratedUser() {
        /*
         Payload to generate JWT Token for Fedarated User:
         {
           "iss": "sdk_2ea21de19cc8bc5e8640c7b227fef2f3", //SDK Key
           "exp": 1709267746, // Timeinterval from now to 1 day
           "jti": "tWhBAwSTmXU6zyQK15Euyy==", // Unique Random string
           "user": {
             "id": "123",
             "name": "Mayuri"
           }
         }
         */
        let token = "eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJzZGtfMmVhMjFkZTE5Y2M4YmM1ZTg2NDBjN2IyMjdmZWYyZjMiLCJleHAiOjE3MDkzNTQxNDYsImp0aSI6InRXc3NBd1NUbVhVNnp5UUsxNUV1eXk9PSIsInVzZXIiOnsiaWQiOiIxMjMiLCJuYW1lIjoiTWF5dXJpIn19.QS99WYjbvh8l4RfN3-NsNz1X7ZGThbBZep3UoM8oSok"
        self.chat = Talkshoplive.Chat(jwtToken: token, isGuest:false, showKey: "8WtAFFgRO1K0", mode: "public", refresh: "manual")
    }
    
    func sendMessage() {
        self.chat?.sendMessage(message: "Hey TalkShopLive Here")
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

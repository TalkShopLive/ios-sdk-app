//
//  ContentView.swift
//  TSL SDK
//
//  Created by Daman Mehta on 2024-01-22.
//
import SwiftUI
import Talkshoplive

struct ChatView: View {
    @State private var showInput: String = ""
    var showID = "vzzg6tNu0qOv"
    var eventID = "8WtAFFgRO1K0"
    @State private var chat: Talkshoplive.Chat? = nil
    @State private var result: String = ""

    
    var body: some View {
        VStack {
            // Link to documentation
            Link("Doc: Chat Class Usage", destination: URL(string: "https://github.com/TalkShopLive/ios-sdk?tab=readme-ov-file#chats")!)
                .padding()
                .foregroundColor(.blue)
            
            // Textfield
            Text("Enter Show ID")
                .multilineTextAlignment(.leading)
            
            // Enter show ID
            TextField("Enter ID", text: $showInput)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2)
                )
                .padding(.horizontal)
                .padding(.bottom)
                .font(.system(size: 22))
                .onAppear {
                    // Set the initial value for idInput
                    showInput = showID
                }
            
            // Render Button
            Button("Create Token - Guest") {
                createTokenGuestUser()
            }
            .frame(width: 240)
            .padding()
            .foregroundColor(.white)
            .background(Color.black)
            .cornerRadius(10)
            
            // Render Button
            Button("Create Token - Federated User") {
                createTokenFederatedUser()
            }
            .frame(width: 240)
            .padding()
            .foregroundColor(.white)
            .background(Color.black)
            .cornerRadius(10)
            
            // Message Count
            Button("Count Messages") {
                countMessages()
            }
            .frame(width: 240)
            .padding()
            .foregroundColor(.white)
            .background(Color.black)
            .cornerRadius(10)
            
            // Render Token or User Id
            if (chat != nil) {
                Text("Token successfully created!")
                    .padding()
                
                // Show success
                Text(result).padding()
            }
        }
        .colorScheme(.light)
        .padding()
        .onAppear() {
            // In live app - Do  not initialize SDK in onAppear but on app load.
            initializeSDK()
        }
    }
    
    func initializeSDK() {
        // Replace the API URL with your actual API endpoint
        let TSL = Talkshoplive.TalkShopLive(clientKey: "sdk_2ea21de19cc8bc5e8640c7b227fef2f3",debugMode: true,testMode: true)
        print(TSL)
    }
    
    func createTokenGuestUser() {
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzZGtfMmVhMjFkZTE5Y2M4YmM1ZTg2NDBjN2IyMjdmZWYyZjMiLCJleHAiOjE3OTkyNjc3NDYsImp0aSI6InRXaEJBd1NUbVhVNnp5UUsxNUV1eXk9PSJ9.1g6lo38-PkYy9EyD4Teq_Nmi2pZYR1_EazuI-u-KISo"
        /*
         Payload to generate JWT Token for Guest User :
         {
         "iss": "sdk_2ea21de19cc8bc5e8640c7b227fef2f3", //SDK Key
         "exp": 1799267746, // Timeinterval from now
         "jti": "tWhBAwSTmXU6zyQK15Euyy==", // Unique Random string
         }
         */
        self.chat = Talkshoplive.Chat(jwtToken: token, isGuest:true, showKey: showInput)
    }
    
    func createTokenFederatedUser() {
        /*
         Payload to generate JWT Token for Fedarated User:
         {
             "iss": "sdk_2ea21de19cc8bc5e8640c7b227fef2f3", //SDK Key
             "exp": 1799267746, // Timeinterval from now
             "jti": "tWhBAwSTmXU6zyQK15Euyy==", // Unique Random string
             "user": {
                 "id": "123",
                 "name": "Mayuri"
             }
         }
         */
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzZGtfMmVhMjFkZTE5Y2M4YmM1ZTg2NDBjN2IyMjdmZWYyZjMiLCJleHAiOjE3OTkyNjc3NDYsImp0aSI6InRXaEJBd1NUbVhVNnp5UUsxNUV1eXk9PSIsInVzZXIiOnsiaWQiOiIxMjMiLCJuYW1lIjoiTWF5dXJpIn19.cUwgqLmLQJ_JV0vNzdUFNdPcBHk6XTf5GqGSArJSnms"
        self.chat = Talkshoplive.Chat(jwtToken: token, isGuest:false, showKey: showInput)
    }
    
    func countMessages() {
        
        self.chat?.countMessages({ count, error in
            if let error = error {
                print(error.localizedDescription)
                self.result = "Error fetching messages count: \(error.localizedDescription)"
            } else {
                print("Message Count : ", count)
                self.result = "Message Count : \(count)"

            }
        })
    }
    
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

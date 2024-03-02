//
//  ContentView.swift
//  TSL SDK
//
//  Created by Daman Mehta on 2024-01-22.
//
import SwiftUI
import Talkshoplive

struct LiveChatView: View {
    @State private var showInput: String = ""
    @State private var message: String = ""
    @State private var result: String = ""
    var showID = "8WtAFFgRO1K0"
    @State private var chat: Talkshoplive.Chat? = nil

    
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

            // Type in message
            TextField("Type your message", text: $message)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2)
                )
                .padding(.horizontal)
                .padding(.bottom)
                .font(.system(size: 22))

            
            // Send message as a guest button
            /* Button("Send Message - Guest") {
                sendMessageGuest()
            }
            .frame(width: 240)
            .padding()
            .foregroundColor(.white)
            .background(Color.black)
            .cornerRadius(10) */
            
            // send message a federated user button
            Button("Send Message - User") {
                sendMessageUser()
            }
            .frame(width: 240)
            .padding()
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(10)
            
            // Show success
            Text(result).padding()
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
        DispatchQueue.global().asyncAfter(deadline: .now() + 3.0) {
                initChat()
            }
    }
    
    func initChat() {
        // initChatGuest()
        initChatUser()
    }
    
    func initChatGuest() {
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzZGtfMmVhMjFkZTE5Y2M4YmM1ZTg2NDBjN2IyMjdmZWYyZjMiLCJleHAiOjE3OTkyNjc3NDYsImp0aSI6InRXaEJBd1NUbVhVNnp5UUsxNUV1eXk9PSIsInVzZXIiOnsibmFtZSI6IndhbG1hcnQtZ3Vlc3QtZmVkZXJhdGVkLXVzZXIifX0.fgHUJFi5oGx93maH0Gdp5nRWRr57K9LvIbPIwQRpQmU"
        self.chat = Talkshoplive.Chat(jwtToken: token, isGuest:true, showKey: showInput)
    }
    
    func initChatUser() {
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzZGtfMmVhMjFkZTE5Y2M4YmM1ZTg2NDBjN2IyMjdmZWYyZjMiLCJleHAiOjE3OTkyNjc3NDYsImp0aSI6InRXaEJBd1NUbVhVNnp5UUsxNUV1eXk9PSIsInVzZXIiOnsiaWQiOiIxMjMiLCJuYW1lIjoiTWF5dXJpIn19.cUwgqLmLQJ_JV0vNzdUFNdPcBHk6XTf5GqGSArJSnms"
        self.chat = Talkshoplive.Chat(jwtToken: token, isGuest:false, showKey: showInput)
    }
    
    func sendMessageGuest() {
        if (self.message != "") {
            self.chat?.sendMessage(message: self.message)
        }
        self.message = ""
        showSuccess()
    }
    
    func sendMessageUser() {
        if (self.message != "") {
            self.chat?.sendMessage(message: self.message)
        }
        self.message = ""
        showSuccess()
    }
    
    func showSuccess() {
        self.result = "Message sent!"
        DispatchQueue.global().asyncAfter(deadline: .now() + 3.0) {
                self.result = ""
            }
    }
}

struct LiveChatView_Previews: PreviewProvider {
    static var previews: some View {
        LiveChatView()
    }
}

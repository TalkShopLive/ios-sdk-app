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
    @State private var isGuest: Bool = false

    
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
                result = ""
                createTokenGuestUser()
            }
            .frame(width: 240)
            .padding()
            .foregroundColor(.white)
            .background(Color.black)
            .cornerRadius(10)
            
            // Render Button
            Button("Create Token - Federated User") {
                result = ""
                createTokenFederatedUser()
            }
            .frame(width: 240)
            .padding()
            .foregroundColor(.white)
            .background(Color.black)
            .cornerRadius(10)
            
            // Message Count
            Button("Update User") {
                result = ""
                updateuser()
            }
            .frame(width: 240)
            .padding()
            .foregroundColor(.white)
            .background(Color.black)
            .cornerRadius(10)
            
            // Message Count
            Button("Count Messages") {
                result = ""
                countMessages()
            }
            .frame(width: 240)
            .padding()
            .foregroundColor(.white)
            .background(Color.black)
            .cornerRadius(10)
            
            // Render Token or User Id
            if (chat != nil) {
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
        let TSL = Talkshoplive.TalkShopLive(clientKey: clientKey,debugMode: true,testMode: false)
    }
    
    func createTokenGuestUser() {
        isGuest = true
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzZGtfMmVhMjFkZTE5Y2M4YmM1ZTg2NDBjN2IyMjdmZWYyZjMiLCJleHAiOjE3OTkyNjc3NDYsImp0aSI6InRXaEJBd1NUbVhVNnp5UUsxNUV1eXk9PSJ9.1g6lo38-PkYy9EyD4Teq_Nmi2pZYR1_EazuI-u-KISo"
        /*
         Payload to generate JWT Token for Guest User :
         {
         "iss": "", //SDK Key
         "exp": 1799267746, // Timeinterval from now
         "jti": "tWhBAwSTmXU6zyQK15Euyy==", // Unique Random string
         }
         */
        self.chat = Talkshoplive.Chat(jwtToken: token, isGuest:self.isGuest, showKey: showInput) {status,error in
            if status {
                self.result = "Token created!"
            } else {
                self.result = error?.localizedDescription ?? ""
            }
        }
    }
    
    func createTokenFederatedUser() {
        isGuest = false
        /*
         Payload to generate JWT Token for Fedarated User:
         {
             "iss": "", //SDK Key
             "exp": 1799267746, // Timeinterval from now
             "jti": "tWhBAwSTmXU6zyQK15Euyy==", // Unique Random string
             "user": {
                 "id": "123",
                 "name": "Mayuri"
             }
         }
         */
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzZGtfNmMyMDc5NWY1ZmFlODc0OWI3OGNiYjBlNjE3MmU5MzEiLCJleHAiOjE3OTkyNjc3NDYsImp0aSI6InRXaEJBdTk5bVhpaXp5UUsxNUUwMHk9PSIsInVzZXIiOnsiaWQiOiIxMDg5OTAwIiwibmFtZSI6Ik1heXVyaSJ9fQ.keXq7s_npUwoC_xCd8hJorZp_bHMkKtoABemnUtCbu4" // production

//        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzZGtfMmVhMjFkZTE5Y2M4YmM1ZTg2NDBjN2IyMjdmZWYyZjMiLCJleHAiOjE3OTkyNjc3NDYsImp0aSI6InRXaEJBd1NUbVhVNnp5UUsxNUV1eXk9PSIsInVzZXIiOnsiaWQiOiIxMjMiLCJuYW1lIjoiTWF5dXJpIn19.1mox9tZ_rbetPaNbSJF75ABw-CLkcy3nykVV52QBxqw"
        self.chat = Talkshoplive.Chat(jwtToken: token, isGuest: self.isGuest, showKey: showInput) {status,error in
            if status {
                self.result = "Token created!"
            } else {
                self.result = error?.localizedDescription ?? ""
            }
        }
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
    
    func updateuser() {
        if isGuest {
            //Upate to fedaratedUser
            let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzZGtfMmVhMjFkZTE5Y2M4YmM1ZTg2NDBjN2IyMjdmZWYyZjMiLCJleHAiOjE3OTkyNjc3NDYsImp0aSI6InRXaEJBd1NUbVhVNnp5UUsxNUV1eXk9PSIsInVzZXIiOnsiaWQiOiIxMjMiLCJuYW1lIjoiTWF5dXJpIn19.cUwgqLmLQJ_JV0vNzdUFNdPcBHk6XTf5GqGSArJSnms"
            self.chat?.updateUser(jwtToken: token, isGuest: false, completion: { status, error in
                if status {
                    self.isGuest = false
                    self.result = "User updated!"
                } else {
                    self.result = error?.localizedDescription ?? ""
                }
            })

        } else {
            //Upate to Guest
            let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzZGtfMmVhMjFkZTE5Y2M4YmM1ZTg2NDBjN2IyMjdmZWYyZjMiLCJleHAiOjE3OTkyNjc3NDYsImp0aSI6InRXaEJBd1NUbVhVNnp5UUsxNUV1eXk9PSJ9.1g6lo38-PkYy9EyD4Teq_Nmi2pZYR1_EazuI-u-KISo"
            self.chat?.updateUser(jwtToken: token, isGuest: true, completion: { status, error in
                if status {
                    self.isGuest = true
                    self.result = "User updated!"
                } else {
                    self.result = error?.localizedDescription ?? ""
                }
            })
        }
    }
    
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

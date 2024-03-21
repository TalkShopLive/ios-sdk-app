//
//  LiveChatView2.swift
//  TSL SDK
//
//  Created by Daman Mehta on 2024-03-10.
//

import SwiftUI
import Talkshoplive

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let sender: String
    let message: String
    
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs.id == rhs.id && lhs.sender == rhs.sender && lhs.message == rhs.message
    }
}
var defaultShowID = "8WtAFFgRO1K0"
struct LiveChat: View {
    @State var messages: [Talkshoplive.MessageBase] = []
    @State private var showInput: String = defaultShowID
    @State private var newMessage: String = ""
    @State private var scrollToBottom = false
    @State private var chat: Talkshoplive.Chat? = nil
    @StateObject private var viewModel = LiveChatModel()
    var myUserId = "federated_user.walmart.123"
    @State private var nextPage : Talkshoplive.MessagePage?
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                
                List {
                    ForEach(messages.indices, id: \.self) { index in
                        let isMe = (messages[index].payload?.sender?.id == myUserId) ? true : false
                        let chatBubble = ChatBubble(message: messages[index], isMe: isMe)
                            .frame(maxWidth: .infinity) // Allow ChatBubble to expand to full width
                            .contentShape(Rectangle()) // Enable interaction with the List
                            .listRowSeparator(.hidden) // Hide the separator line
                        
                        if isMe {
                            chatBubble.swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button {
                                    // Perform action when the button is tapped
                                    // For example, delete the message
                                    self.deleteMessage(at: index)
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(.red)
                            }
                        } else {
                            chatBubble
                        }
                    }
                }
                .contentShape(Rectangle()) // Enable interaction with the List
                .listStyle(PlainListStyle()) // Remove default inset
                
                .onChange(of: messages.count) { _ in
                    // Scroll to the last index when the number of messages changes
                    scrollView.scrollTo(messages.count - 1, anchor: .bottom)
                }
                
            }
            
            .onReceive(viewModel.$message, perform: { newMessage in
                if let newMessage = newMessage {
                    if newMessage.payload?.key == .messageDeleted {
                        if let index = messages.firstIndex(where: { messageObject in
                            messageObject.published == newMessage.payload?.timeToken
                        }) {
                            messages.remove(at: index)
                        }
                    } else {
                        messages.append(newMessage)
                    }
                }
                scrollToBottom = true
            })
            
            HStack {
                TextField("Type a message", text: $newMessage)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                    .padding(.leading)
                    .font(.system(size: 16))
                
                Button(action: sendMessage) {
                    Text("Send")
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding(.trailing)
            
        }
        
        .navigationTitle("Chat")
        .onAppear() {
            initializeSDK()
        }
        
        .onDisappear() {
            self.chat?.clean()
        }
        
        
    }
    
    
    
    func initializeSDK() {
        // Assuming SDK initialization is asynchronous
        Talkshoplive.TalkShopLive(clientKey: "sdk_2ea21de19cc8bc5e8640c7b227fef2f3", debugMode: true, testMode: true) { result in
            switch result {
            case .success:
                print("SDK Initialized Successfully")
                
                // Init chat on success
                initChat()
            case .failure(let error):
                print("SDK Initialization Failed:: \(error.localizedDescription)")
            }
        }
    }
    
    private func deleteMessage(at index: Int) {
//           messages.remove(at: index)
        let message = self.messages[index]
        if let timetoken = message.published {
            print("TimeToken",timetoken)
           
            self.chat?.deleteMessage(timeToken: timetoken, completion: { status, error in
                if status {
//                    self.messages.remove(at: index)
                    print("APP : Message deleted Successfully", status)
                } else {
                    print("APP : Error", error?.localizedDescription)
                }
            })
        }
    }
    
    func initChat() {
//         initChatGuest()
        initChatUser()
        
//        // Fetch messages on init
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            fetchMessageHistory()
        }
    }
    
    func initChatGuest() {
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzZGtfMmVhMjFkZTE5Y2M4YmM1ZTg2NDBjN2IyMjdmZWYyZjMiLCJleHAiOjE3OTkyNjc3NDYsImp0aSI6InRXaEJBd1NUbVhVNnp5UUsxNUV1eXk9PSIsInVzZXIiOnsibmFtZSI6IndhbG1hcnQtZ3Vlc3QtZmVkZXJhdGVkLXVzZXIifX0.fgHUJFi5oGx93maH0Gdp5nRWRr57K9LvIbPIwQRpQmU"
        self.chat = Talkshoplive.Chat(jwtToken: token, isGuest:true, showKey: showInput)
        self.chat?.delegate = viewModel
    }
    
    func initChatUser() {
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzZGtfMmVhMjFkZTE5Y2M4YmM1ZTg2NDBjN2IyMjdmZWYyZjMiLCJleHAiOjE3OTkyNjc3NDYsImp0aSI6InRXaEJBd1NUbVhVNnp5UUsxNUV1eXk9PSIsInVzZXIiOnsiaWQiOiIxMjMiLCJuYW1lIjoiTWF5dXJpIn19.cUwgqLmLQJ_JV0vNzdUFNdPcBHk6XTf5GqGSArJSnms"
        self.chat = Talkshoplive.Chat(jwtToken: token, isGuest:false, showKey: showInput)
        self.chat?.delegate = viewModel
    }
    
    private func sendMessage_temp() {
        if !newMessage.isEmpty {
            let message = ChatMessage(sender: "Me", message: newMessage)
            newMessage = ""
            scrollToBottom = true
        }
    }
    
    private func sendMessage() {
        if (!newMessage.isEmpty) {
            self.chat?.sendMessage(message: newMessage, completion: {status, error in
                if status {
                    print("APP : Message Send Successfully", status)
                } else {
                    print("APP : Error", error)
                }
            })
            newMessage = ""
            scrollToBottom = true
            // showSuccess()
        }
    }
    
    func showSuccess() {
        // self.result = "Message sent!"
        DispatchQueue.global().asyncAfter(deadline: .now() + 3.0) {
            // self.result = ""
        }
    }
    
    func fetchMessageHistory(isLoadMore: Bool = false) {
        
        self.chat?.getChatMessages(limit: 25,start: (nextPage != nil ? nextPage?.start : nil) ) { result in
            switch result {
            case let .success((messageArray,page)):
                print("History", messageArray)
                if !isLoadMore {
                    self.scrollToBottom = true
                }
                // Handle the successful result with the message array and optional nextPage
//                          print("Received chat messages:", messageArray)
                //          print("Received next page:", page)
                self.messages.insert(contentsOf: messageArray, at: 0)
                nextPage = page
            case .failure(let error):
                print("Error fetching chat messages: \(error.localizedDescription)")
            }
        }
    }
}

class LiveChatModel: ObservableObject, ChatDelegate {
    @Published var message: MessageBase?

    
    func onDeleteMessage(_ message: Talkshoplive.MessageBase) {
        print("APP : Message Removed => ", message)
        self.message = message
        dump(message)
    }
    
    func onNewMessage(_ message: Talkshoplive.MessageBase) {
        print("APP : Recieved New Message => ", message)
        self.message = message
        dump(message)
    }
}

struct ChatBubble: View {
    var message: Talkshoplive.MessageBase // Replace YourMessageType with the actual type of your messages
    var isMe: Bool = false // Add a property to determine if the message is sent by the user
    
    var body: some View {
        HStack(spacing: 0) {
    
            Spacer(minLength: 0)
            
            VStack(alignment: isMe ? .trailing : .leading, spacing: 5) {
                if let senderName = message.payload?.sender?.name, !senderName.isEmpty {
                    Text(senderName)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Text(message.payload?.text ?? "")
                    .padding()
                    .background(isMe ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: isMe ? .trailing : .leading)
            }
            .frame(maxWidth: .infinity, alignment: isMe ? .trailing : .leading) // Expand VStack to fill the width

            Spacer(minLength: 0)
        }
        .padding(.vertical, 5)
    }
}




struct LiveChat_Previews: PreviewProvider {
    static var previews: some View {
        LiveChat()
    }
}

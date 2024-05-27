//
//  LiveChatView2.swift
//  TSL SDK
//
//  Created by Daman Mehta on 2024-03-10.
//

import SwiftUI
import Talkshoplive

var defaultShowID = "8WtAFFgRO1K0"


//var defultShowID =  "ZKl4cBEzfV_A" // threaded message
struct LiveChat: View {
    @State private var refreshCount = 0 // Counter to track refreshes

    @State var messages: [Talkshoplive.MessageBase] = []
    @State private var showInput: String = defaultShowID
    @State private var newMessage: String = ""
    @State private var scrollToBottom = false
    @State private var loadMoreData = true
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
                                    
                        var isLiked: Bool = messages[index].actions?.contains(where: { action in
                            (action.publisher ?? "") == myUserId
                        }) ?? false
                        
                        ChatBubble(message: messages[index], isMe: isMe, actions: messages[index].actions ?? [MessageAction]())
                            .frame(maxWidth: .infinity) // Allow ChatBubble to expand to full width
                            .contentShape(Rectangle()) // Enable interaction with the List
                            .listRowSeparator(.hidden) // Hide the separator line
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                if isMe {
                                    Button {
                                        // Perform action when the button is tapped
                                        // For example, delete the message
                                        self.deleteMessage(at: index)
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .tint(.red)
                                }
                                
                                Button {
                                    if isLiked {
                                        self.UnLikeComment(at: index)
                                    } else {
                                        self.LikeComment(at: index)
                                    }
                                    isLiked.toggle()
                                } label: {
                                    Image(systemName: isLiked ? "heart.fill" : "heart")

                                }
                                .tint(isLiked ? .blue : .gray) // Adjust tint color based on isLiked state

                            }
                            .onAppear {
                                // Detect when the last item is displayed and call loadMoreData if necessary
                                if index == 0 && loadMoreData {
                                    fetchMessageHistory(isLoadMore: true)
                                }
                            }
                    }
                }
                .contentShape(Rectangle()) // Enable interaction with the List
                .listStyle(PlainListStyle()) // Remove default inset
                
                .onChange(of: messages.count) { _ in
                    if self.scrollToBottom {
                        // Scroll to the last index when the number of messages changes
                        scrollView.scrollTo(messages.count - 1, anchor: .bottom)
                    }
                    refreshCount += 1
                }
            }
            
            
            .onReceive(viewModel.$message, perform: { newMessage in
                if let newMessage = newMessage {
                    if let key = newMessage.payload?.key, key.isEqual(to: .messageDeleted) {
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
            
            .onReceive(viewModel.$messageAction, perform: { messageAction in
                if let newMessageAction = messageAction {
                    print("\n APP :: Like Comment => newMessageAction", newMessageAction)
                    if let messageIndex =  self.messages.firstIndex(where: { message in
                        (message.published ?? "") == (newMessageAction.messageTimetoken ?? "")
                    }) {
                        self.messages[messageIndex].actions?.append(newMessageAction)
                    }
                }
            })
            
            .onReceive(viewModel.$removedMessageAction, perform: { messageAction in
                if let removedMessageAction = messageAction {
                    print("\n APP :: Unlike Comment => removedMessageAction", removedMessageAction)
                    if let messageIndex =  self.messages.firstIndex(where: { message in
                        (message.published ?? "") == (removedMessageAction.messageTimetoken ?? "")
                    }) {
                        if let actionsIndex =  self.messages[messageIndex].actions?.firstIndex(where: { action in
                            (action.actionTimetoken ?? 0) == (removedMessageAction.actionTimetoken ?? 0)
                        }) {
                            self.messages[messageIndex].actions?.remove(at: actionsIndex)
                        }
                    }
                    
                    
                }
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
                
                Text("Refresh Count: \(refreshCount)")
            }
            .padding(.trailing)
            
        }
        
        .navigationTitle("Chat")
        .onAppear() {
            initializeSDK()
            nextPage = nil
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
    
    func initChat() {
//         initChatGuest()
        initChatUser()
        
//        // Fetch messages on init
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            fetchMessageHistory()
        }
    }
    
    func initChatGuest() {
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzZGtfMmVhMjFkZTE5Y2M4YmM1ZTg2NDBjN2IyMjdmZWYyZjMiLCJleHAiOjE3OTkyNjc3NDYsImp0aSI6InRXaEJBd1NUbVhVNnp5UUsxNUV1eXk9PSJ9.AJxhg3FOX_vlWo9Zx8yg_YQUbJjw3PPThXViJ2EZU0s"
        self.chat = Talkshoplive.Chat(jwtToken: token, isGuest:true, showKey: showInput) {status,error in
            if let error = error {
                print("APP : Error", error.localizedDescription)
            }
        }
        self.chat?.delegate = viewModel
    }
    
    func initChatUser() {
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzZGtfMmVhMjFkZTE5Y2M4YmM1ZTg2NDBjN2IyMjdmZWYyZjMiLCJleHAiOjE3OTkyNjc3NDYsImp0aSI6InRXaEJBd1NUbVhVNnp5UUsxNUV1eXk9PSIsInVzZXIiOnsiaWQiOiIxMjMiLCJuYW1lIjoiTWF5dXJpIn19.1mox9tZ_rbetPaNbSJF75ABw-CLkcy3nykVV52QBxqw"
        self.chat = Talkshoplive.Chat(jwtToken: token, isGuest:false, showKey: showInput) {status,error in
            if let error = error {
                print("APP : Error", error.localizedDescription)
            }
        }
        self.chat?.delegate = viewModel
    }
    
    func fetchMessageHistory(isLoadMore: Bool = false) {
        if loadMoreData {
            self.chat?.getChatMessages(limit: 30,start: (nextPage != nil ? nextPage?.start : nil) ) { result in
                switch result {
                case let .success((messageArray,page)):
                    if !isLoadMore {
                        self.scrollToBottom = true
                    } else {
                        self.scrollToBottom = false
                    }
                    // Handle the successful result with the message array and optional nextPage
//                              print("Received chat messages:", messageArray)
                    //          print("Received next page:", page)
                    if messageArray.count > 0 && page != nil{
                        self.messages.insert(contentsOf: messageArray, at: 0)
                        loadMoreData = true
                    } else {
                        loadMoreData = false
                    }
                    nextPage = page
                case .failure(let error):
                    print("APP : Error fetching chat messages: \(error.localizedDescription)")
                }
            }
        }

    }
    
    private func sendMessage() {
        if (!newMessage.isEmpty) {
            self.chat?.sendMessage(message: newMessage, completion: {status, error in
                if status {
                    print("APP : Message Send Successfully", status)
                } else {
                    if let error = error {
                        print("APP : Error", error.localizedDescription)
                    }
                }
            })
            newMessage = ""
            scrollToBottom = true
        }
    }
    
    private func deleteMessage(at index: Int) {
        let message = self.messages[index]
        if let timetoken = message.published {
            print("TimeToken",timetoken)
           
            self.chat?.deleteMessage(timeToken: timetoken, completion: { status, error in
                if status {
//                    self.messages.remove(at: index)
                    print("APP : Message deleted Successfully", status)
                } else {
//                    print("APP : Error", error?.localizedDescription)
                }
            })
        }
    }
    
    private func LikeComment(at index: Int) {
        let message = self.messages[index]
        if let timetoken = message.published {
            print("APP :: Like Comment => TimeToken",timetoken)
           
            self.chat?.likeComment(timeToken: timetoken, completion: { status, error in
                if status {
                    print("APP : Liked comment Successfully", status)
                } else {
                    print("APP : Liked comment Error", error?.localizedDescription ?? "")
                }
            })
        }
    }
    
    private func UnLikeComment(at index: Int) {
        let message = self.messages[index]
        var actionTimetoken : Int?
        
        if let actionsIndex =  self.messages[index].actions?.firstIndex(where: { action in
            (action.publisher ?? "") == myUserId
        }) {
            actionTimetoken = message.actions?[actionsIndex].actionTimetoken
        }
        if let timetoken = message.published, let actionTimetoken = actionTimetoken {
            print("APP :: Unlike Comment => TimeToken",timetoken, "actionTimeToken", actionTimetoken)

            self.chat?.UnlikeComment(timeToken: timetoken, actionTimeToken: actionTimetoken, completion: { status, error in
                if status {
                    if let actionsIndex =  self.messages[index].actions?.firstIndex(where: { action in
                        (action.actionTimetoken ?? 0) == actionTimetoken
                    }) {
                        self.messages[index].actions?.remove(at: actionsIndex)
                    }
                    print("APP : Unliked comment Successfully", status)
                } else {
                    print("APP : Unliked comment Error", error?.localizedDescription ?? "")
                }
            })
        }
    }
}

class LiveChatModel: ObservableObject, ChatDelegate {
    
    @Published var message: MessageBase?
    @Published var messageAction: MessageAction?
    @Published var removedMessageAction: MessageAction?

    
    func onDeleteMessage(_ message: Talkshoplive.MessageBase) {
        print("APP : Message Removed => ")//, message)
        self.message = message
        dump(message)
    }
    
    func onNewMessage(_ message: Talkshoplive.MessageBase) {
        print("APP : Recieved New Message => ")//, message)
        self.message = message
        //If it's threaded message, it will have original message details
        if let originalMessage = message.payload?.original?.message {
            print("APP : Original message's sender details", originalMessage.sender ?? "")
            print("APP : Original message details", originalMessage.text ?? "")
        }
        dump(message)
    }
    
    func onStatusChange(error: Talkshoplive.APIClientError) {
        //If token revoked , handle error.
        print("APP : onStatusChanged Listener")

        //1. Using switch case
        switch error {
        case .PERMISSION_DENIED:
            print("APP : Permission Denied")
        case .CHAT_TIMEOUT:
            print("APP : Chat Timeout")
        case .CHAT_CONNECTION_ERROR:
            print("APP : Chat Timeout")
        default:
            break
        }
        
        //2. Using if condition
        if case .PERMISSION_DENIED = error {
            print("APP : Permission Denied")
            // Additional handling for token expiration
        } else if case .CHAT_TIMEOUT = error {
            print("APP : Chat Timeout")
            // Additional handling for permission denied
        } else {
            print(error.localizedDescription)
        }
    }
    func onLikeComment(_ messageAction: Talkshoplive.MessageAction) {
        print("APP :: Like Comment => Listener")
        self.messageAction = messageAction
    }
    func onUnlikeComment(_ messageAction: MessageAction) {
        print("APP :: Unlike Comment => Listener")
        self.removedMessageAction = messageAction
    }
    
}

struct ChatBubble: View {
    
    var message: Talkshoplive.MessageBase // Replace YourMessageType with the actual type of your messages
    var isMe: Bool = false // Add a property to determine if the message is sent by the user
    var actions: [MessageAction] // Replace `Action` with the actual type of your actions

    var body: some View {
        HStack(spacing: 0) {
    
            Spacer(minLength: 0)
            
            let isThreaded = (message.payload?.original != nil)
            VStack(alignment: isMe ? .trailing : .leading, spacing: 5) {
                //START : Threaded message
//                if let originalMessage = message.payload?.original?.message {
//                    VStack(alignment: .leading, spacing: 5) {
//                        if let senderName = originalMessage.sender?.name, !senderName.isEmpty {
//                            Text(senderName)
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                        }
//                        Text(originalMessage.text ?? "")
//                            .padding()
//                            .background(.green)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                            .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: isMe ? .trailing : .leading)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                }
                //END : Threaded message
                
                if let senderName = message.payload?.sender?.name, !senderName.isEmpty {
                    Text(senderName)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment:isMe ? .trailing : (isThreaded ? .center : .leading))
                }
                
                Text(message.payload?.text ?? "")
                    .padding()
                    .background(isMe ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: isMe ? .trailing : (isThreaded ? .center : .leading))
                
                // Print or display the actions
                   if !actions.isEmpty {
                       VStack(alignment: .leading) {
                           ForEach(actions.indices, id: \.self) { index in
                               Text("Action by: \(actions[index].publisher ?? "Unknown")") // Replace with actual property names
                                   .font(.footnote)
                                   .foregroundColor(.secondary)
                           }
                       }
                       .frame(maxWidth: .infinity, alignment: isMe ? .trailing : .leading)
                   }
               
            }
            .frame(maxWidth: .infinity, alignment: isMe ? .trailing : .leading) // Expand VStack to fill the width

            Spacer(minLength: 0)
        }
        .padding(.vertical, 5)
    }
    
    struct LikeButtonStyle: ButtonStyle {
        var isLiked: Bool

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .imageScale(.large)
                .foregroundColor(isLiked ? .red : .gray)
        }
    }
}




struct LiveChat_Previews: PreviewProvider {
    static var previews: some View {
        LiveChat()
    }
}

//
//  LiveChatView2.swift
//  TSL SDK
//
//  Created by Daman Mehta on 2024-03-10.
//

import SwiftUI
import Talkshoplive
import GiphyUISDK


var defultShowID =  "KsqM-Z5Z8eim" // threaded message
struct LiveChat: View {
    @State private var refreshCount = 0 // Counter to track refreshes

    @State var messages: [Talkshoplive.MessageBase] = []
    @State private var showInput: String = defaultShowID
    @State private var newMessage: String = ""
    @State private var scrollToBottom = false
    @State private var loadMoreData = true
    @State private var chat: Talkshoplive.Chat? = nil
    @StateObject private var viewModel = ChatViewModel()
    var myUserId = "federated_user.walmart.123"
    @State private var nextPage : Talkshoplive.MessagePage?
    
    //Giphy
    @State private var isShowingGiphyPicker = false
    
    init() {
        Giphy.configure(apiKey:"w2cYrP7vfThDdKlcfPsHgQ26cQf6E9mg")
    }
    
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
            
            .onReceive(viewModel.$selectedGifData, perform: { gifData in
                if let gifData = gifData {
                    print("\n LiveChat : GifData recieved")
                    self.sendGif(gifData: gifData)
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
                
                Button("gif") {
                    isShowingGiphyPicker = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
//                Text("Refresh Count: \(refreshCount)")
            }
            .padding(.trailing)
            .sheet(isPresented: $isShowingGiphyPicker) {
                GiphyPicker(delegate: viewModel)
            }
            
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
        Talkshoplive.TalkShopLive(clientKey: clientKey, debugMode: true, testMode: true) { result in
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
    
    private func sendGif(gifData:GPHMedia) {
            let id = gifData.id
            let aspectRatio : Double = Double((gifData.images?.original?.width ?? 0) / (gifData.images?.original?.height  ?? 0))
            self.chat?.sendMessage(message: id, type: .giphy, aspectRatio: aspectRatio, completion: {status, error in
                if status {
                    print("APP : GIF Send Successfully", status)
                } else {
                    if let error = error {
                        print("APP : GIF Error", error.localizedDescription)
                    }
                }
            })
            newMessage = ""
            scrollToBottom = true
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

struct LiveChat_Previews: PreviewProvider {
    static var previews: some View {
        LiveChat()
    }
}

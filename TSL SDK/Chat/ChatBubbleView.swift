//
//  ChatBubbleView.swift
//  TSL SDK
//
//  Created by Mayuri on 2024-06-03.
//

import Foundation
import SwiftUI
import Talkshoplive
import GiphyUISDK


struct ChatBubble: View {
    
    var message: Talkshoplive.MessageBase // Replace YourMessageType with the actual type of your messages
    var isMe: Bool = false // Add a property to determine if the message is sent by the user
    var actions: [MessageAction] // Replace `Action` with the actual type of your actions
    
    @State private var gifMedia: GPHMedia? // Store the fetched GIF media
    @State private var isFetchingGIF: Bool = false


    var body: some View {
        HStack(spacing: 0) {
    
            Spacer(minLength: 0)
            
            let isThreaded = (message.payload?.original != nil)
            VStack(alignment: isMe ? .trailing : .leading, spacing: 5) {
                //START : Threaded message
                if let originalMessage = message.payload?.original?.message {
                    VStack(alignment: .leading, spacing: 5) {
                        if let senderName = originalMessage.sender?.name, !senderName.isEmpty {
                            Text(senderName)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Text(originalMessage.text ?? "")
                            .padding()
                            .background(.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: isMe ? .trailing : .leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                //END : Threaded message
                
                if let senderName = message.payload?.sender?.name, !senderName.isEmpty {
                    Text(senderName)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment:isMe ? .trailing : (isThreaded ? .center : .leading))
                }
                
                if message.payload?.type == .giphy {
                    // Display GIF
                    if let gifMedia = gifMedia {
                        // Display fetched GIF
                        GPHMediaViewWrapper(media: gifMedia)
                            .aspectRatio(gifMedia.aspectRatio, contentMode: .fit)
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.6)
                            .cornerRadius(16)
                        
                        //OR else access URL directly from gifMedia
                        
                    } else {
                        // Fetch GIF asynchronously
                        ProgressView()
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.7)
                            .onAppear {
                                fetchGIFByID(message.payload?.text ?? "")
                            }
                    }
                } else {
                    Text(message.payload?.text ?? "")
                        .padding()
                        .background(isMe ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: isMe ? .trailing : (isThreaded ? .center : .leading))
                }
                
                
                
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
    
    // Function to fetch GIF by its ID
        private func fetchGIFByID(_ gifID: String) {
            isFetchingGIF = true
            GiphyCore.shared.gifByID(gifID) { response, error in
                if let media = response?.data {
                    DispatchQueue.main.async {
                        self.gifMedia = media
                    }
                } else if let error = error {
                    print("Error fetching GIF:", error)
                }
                self.isFetchingGIF = false

            }
        }
}


struct GPHMediaViewWrapper: UIViewRepresentable {
    var media: GPHMedia
    
    func makeUIView(context: Context) -> GPHMediaView {
        let mediaView = GPHMediaView()
        mediaView.media = media
        return mediaView
    }
    
    func updateUIView(_ uiView: GPHMediaView, context: Context) {
        uiView.media = media
    }
}

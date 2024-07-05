//
//  LiveChatViewModel.swift
//  TSL SDK
//
//  Created by Mayuri on 2024-06-03.
//

import Foundation
import SwiftUI
import Talkshoplive
import GiphyUISDK


class ChatViewModel: ObservableObject, ChatDelegate {
    
    @Published var message: MessageBase?
    @Published var messageAction: MessageAction?
    @Published var removedMessageAction: MessageAction?
    
    //Giphy
    @Published var selectedGIFURL: URL?
    @Published var isShowingGiphyPicker = false
    
    @Published var selectedGifData: GPHMedia?


    
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
        
        //Get GiphyId
        if message.payload?.type == .giphy {
            print("Giphy Id", message.payload?.text)
        }
        print("GiphyId")
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


extension ChatViewModel: GiphyPickerDelegate {
    
    func didSelectGIF(url: URL) {
        selectedGIFURL = url
        isShowingGiphyPicker = false
    }
    
    func didSelectedGifData(media: GPHMedia) {
        selectedGifData = media
    }
    
}

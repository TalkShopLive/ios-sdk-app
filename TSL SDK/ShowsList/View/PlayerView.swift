//
//  ShowList.swift
//  TSL SDK
//
//  Created by Mayuri on 2024-03-27.
//

import Foundation
import AVKit
import SwiftUI
import Talkshoplive

struct PlayerView: View {
    
    @StateObject private var viewModel = PlayerViewModel()
    let showID: String
    @State private var timer: Timer?
    @State private var counter: Int = 1
    @State private var eventObject : Talkshoplive.EventData? = nil
    let showInstance = Talkshoplive.Show()

    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
//                Text("No data available")
//                    .foregroundColor(.gray)
//                    .padding()
                
                if let eventData = viewModel.eventData {
                    VStack(alignment: .leading, spacing: 5) {

                        // Show Title and Status in HStack
                        HStack {
                            Text(eventData.name ?? "N/A")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text(eventData.status ?? "N/A")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                        .padding([.horizontal, .top])

                        Divider()

                        // HLS URL (Label and Link if available)
                        if let hlsPlaybackUrl = eventData.hlsPlaybackUrl,
                           let hlsURL = URL(string: hlsPlaybackUrl) {
                            VStack(alignment: .leading) {
                                Text("HLSPlayBack URL:")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Link(hlsPlaybackUrl, destination: hlsURL)
                                    .foregroundColor(.blue)
                            }
                            .padding([.horizontal, .bottom])
                        }

                        // Video Player
                        if let videoURL = URL(string: eventData.hlsPlaybackUrl ?? "") {
                            VideoPlayer(player: AVPlayer(url: videoURL))
                                .frame(height: 350)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        } else {
                            Text("Invalid video URL")
                                .foregroundColor(.red)
                                .padding(.horizontal)
                        }
                        
                        Spacer()
                    }
                } else if let showData = viewModel.showData {
                    VStack(alignment: .leading, spacing: 5) {

                        // Show Title and Status in HStack
                        HStack {
                            Text(showData.name ?? "N/A")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text(showData.status ?? "N/A")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                        .padding([.horizontal, .top])

                        Divider()

                        // HLS URL (Label and Link if available)
                        if let hlsPlaybackUrl = showData.hlsPlaybackUrl,
                           let hlsURL = URL(string: hlsPlaybackUrl) {
                            VStack(alignment: .leading) {
                                Text("HLSPlayBack URL:")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Link(hlsPlaybackUrl, destination: hlsURL)
                                    .foregroundColor(.blue)
                            }
                            .padding([.horizontal, .bottom])
                        }

                        // Video Player
                        if let videoURL = URL(string: showData.hlsPlaybackUrl ?? "") {
                            VideoPlayer(player: AVPlayer(url: videoURL))
                                .frame(height: 350)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        } else {
                            Text("Invalid video URL")
                                .foregroundColor(.red)
                                .padding(.horizontal)
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchShowData(showKey: showID)//fetchCurrentEvent(showKey: showID)
        }
        
        .onDisappear {
            stopPolling()
        }
    }
    
    private func startPolling() {
        viewModel.fetchCurrentEvent(showKey: showID)
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
            pollCurrentEvent()
        }
    }
    private func pollCurrentEvent() {
        counter = counter + 1
        viewModel.fetchCurrentEvent(showKey: showID)
        if viewModel.errorMessage == nil {
            stopPolling()
        }
    }
    
    // clear in disappear
    private func stopPolling() {
        timer?.invalidate()
        timer = nil
        counter = 1
    }
}




struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(showID: "")
    }
}

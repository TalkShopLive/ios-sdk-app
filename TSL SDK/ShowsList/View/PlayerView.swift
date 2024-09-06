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

import SwiftUI
import AVKit

struct PlayerView: View {
    
    @StateObject private var viewModel = PlayerViewModel()
    let showID: String
    
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
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
                .navigationBarTitle("Live Player", displayMode: .inline)
                .navigationBarItems(trailing:
                                        Menu {
                    Button(action: {
                        // Trigger navigation to ChatView
                    }) {
                        Text("Chat")
                    }
                    
                    Button(action: {
                        // Trigger navigation to ProductsView
                    }) {
                        Text("Products")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                })
            } else {
                Text("No data available")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .onAppear {
            viewModel.fetchShowData(showKey: showID)
        }
    }
}


struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(showID: "")
    }
}

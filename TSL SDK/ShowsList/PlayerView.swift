//
//  ShowList.swift
//  TSL SDK
//
//  Created by Mayuri on 2024-03-27.
//

import Foundation
import AVKit
import SwiftUI

struct PlayerView: View {
    
    let showData: ShowsDataModel?
    @Environment(\.presentationMode) var presentationMode // Access the presentation mode to control navigation
    @State private var path = NavigationPath() // State to manage navigation path

    init(showData: ShowsDataModel?) {
        self.showData = showData
    }

    var body: some View {
        NavigationStack(path: $path) { // Use NavigationStack with path
            VStack(alignment: .leading, spacing: 5) {

                // Show Title and Status in HStack
                HStack {
                    if let name = showData?.name {
                        Text(name)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    if let status = showData?.status {
                        Text(status)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                }
                .padding([.horizontal, .top]) // Only padding on horizontal and top edges

                Divider()

                // HLS URL (Label and Link if available)
                if let hlsURLString = showData?.hlsURL, let hlsURL = URL(string: hlsURLString) {
                    VStack(alignment: .leading) {
                        Text("HLS URL:")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Link(hlsURLString, destination: hlsURL)
                            .foregroundColor(.blue)
//                            .lineLimit(1)
//                            .truncationMode(.tail)
                    }
                    .padding([.horizontal, .bottom]) // Padding only on horizontal and bottom edges
                }

                // Video Player
                let url = showData?.hlsURL ?? "https://assets-dev.talkshop.live/uploads/upcoming/2754/1115e3d8-db8d-4fba-854c-f99c32c16770_transcoded.mp4?orientation="
                if let videoURL = URL(string: url) {
                    VideoPlayer(player: AVPlayer(url: videoURL))
                        .frame(height: 350)
                        .cornerRadius(10)
                        .padding(.horizontal) // Padding on horizontal edges to align with other content
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
                    path.append("LiveChat") // Trigger navigation to ChatView

                }) {
                    Text("Chat")
                }
                
                Button(action: {
                    // Handle Option 2 action
                    path.append("ProductsView") // Trigger navigation to ChatView
                }) {
                    Text("Products")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .imageScale(.large)
            }
            )
            .navigationDestination(for: String.self) { destination in
                if destination == "LiveChat" {
                    LiveChat()
                } else if  destination == "ProductsView" {
                    ProductsView()
                }
            }
            .transition(.move(edge: .trailing)) // Transition animation for navigation
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
//        PlayerView(showData: nil)
        PlayerView(showData: ShowsDataModel(name: "Mayuri", postImage: "https://example.com/image.jpg", details: "This is test details"))
    }
}

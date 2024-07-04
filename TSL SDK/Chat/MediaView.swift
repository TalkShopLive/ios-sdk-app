//
//  MediaView.swift
//  TSL SDK
//
//  Created by Mayuri on 2024-06-03.
//

import Foundation
import SwiftUI
import GiphyUISDK


struct MediaView: View {
    var media: GPHMedia
    
    var body: some View {
        switch media.type {
        case .gif:
            // Display the GIF
            if let gifURL = media.url(rendition: .original, fileType: .gif) {
                AsyncImage(url: URL(string:gifURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    default:
                        ProgressView()
                    }
                }
            }
        default:
            // Display other media types (e.g., images, videos)
            Text("Unsupported media type")
        }
    }
}

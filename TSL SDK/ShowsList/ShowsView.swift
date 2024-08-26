//
//  ShowListView.swift
//  TSL SDK
//
//  Created by Mayuri on 2024-07-30.
//

import Foundation
import SwiftUI

struct ShowsView: View {
    // MARK:- PROPERTIES
    
    @State var showData: ShowsDataModel
    @State private var isLiked: Bool = false
    @State private var isLikeAnimation: Bool = false
    
    var width = UIScreen.main.bounds.width-20
    @State private var isVisible = false
    
    // Example URL for post image
    let imageURL = URL(string: "https://cdn-dev.talkshop.live/eyJidWNrZXQiOiJ0c2wtaW1hZ2VzLWRldmVsb3BtZW50Iiwia2V5IjoidmFyaWFudF9pbWFnZXMvMTUyNDcvb3JpZ2luYWwvd2lkZ2V0LXdpZGdldHMuanBnIiwiZWRpdHMiOnsicmVzaXplIjp7IndpZHRoIjo2MDAsImZpdCI6ImNvbnRhaW4ifX19")!
    
    // MARK:- FUNCTION
    
    func hideAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(800)) {
            isLikeAnimation = false
        }
    }
    
    // MARK:- BODY
    
    var body: some View {
        VStack(spacing: 10) {
            
            // Top Image
            AsyncImage(url: URL(string: showData.postImage)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(width: width, height: UIScreen.main.bounds.height / 3.5)
                        .background(Color.gray.opacity(0.2)) // Placeholder color
                        
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: UIScreen.main.bounds.height / 3.5)
                        
                case .failure:
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.red)
                        .frame(width: width, height: UIScreen.main.bounds.height / 3.5)
                @unknown default:
                    EmptyView()
                }
            }
            
            // Bottom Profile Section
            VStack(alignment: .leading) {
                HStack {
                    Image("user") // User Profile Image
//                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.gray, lineWidth: 0.5)
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(showData.name)
                            .font(Font.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text(showData.details)
                            .font(Font.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    .padding(.leading, 8)

                    Spacer() // This will push the content to the left
                }
                .padding()
                .background(Color.white) // Background color for the profile section
                .shadow(radius: 5) // Optional shadow
                .frame(width: width)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10.0)) // Rounded corners for the profile section
        }
        .background(Color.white) // Background color for the entire card
        .clipShape(RoundedRectangle(cornerRadius: 10.0)) // Rounded corners for the entire view
        .shadow(radius: 10) // Optional shadow
        .animation(.spring(), value: isLikeAnimation) // Animation for the like button
        .opacity(isVisible ? 1 : 0)
                .onAppear {
                    withAnimation(.easeIn(duration: 0.5)) {
                        isVisible = true
                    }
                }
        
    }
}

struct ShowsView_Previews: PreviewProvider {
    static var previews: some View {
        ShowsView(showData: ShowsDataModel(name: "John Doe", postImage: "https://example.com/image.jpg", details: "Details about the post"))
    }
}

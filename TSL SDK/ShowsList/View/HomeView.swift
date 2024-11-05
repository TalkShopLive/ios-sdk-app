//
//  HomeView.swift
//  TSL SDK
//
//  Created by Mayuri on 2024-07-30.
//

import Foundation

import SwiftUI

struct HomeView: View {
    // MARK:- PROPERTIES
    
    init(){
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    @State private var gridLayout: [GridItem] = [GridItem(.flexible())]
    @StateObject private var viewModel = HomeViewModel()
    @State private var path = NavigationPath() // State to manage navigation path

    
    // MARK:- BODY
    
    var body: some View {
//        NavigationStack(path: $path) {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .navigationBarTitle("Upcoming Shows", displayMode: .inline)
            } else if let error = viewModel.error {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
                    .navigationBarTitle("Upcoming Shows", displayMode: .inline)
            } else {
                ScrollView(.vertical, showsIndicators:false) {
                    LazyVGrid(columns: gridLayout, alignment: .center, spacing: 15){
                        ForEach(viewModel.showsData, id: \.id) { item in
                            NavigationLink(destination: PlayerView(showID: item.showKey ?? "rrr")) {
                                ShowsView(showData: item)
                                    .transition(.asymmetric(insertion: .opacity.combined(with: .scale), removal: .opacity))
                                    .onAppear {
                                        withAnimation(.easeIn(duration: 0.3)) {
                                            // Trigger animation on appearance
                                        }
                                    }
                            }
                        }
                    }//: GRID
                    .padding(5)
                }//: SCROLL
                .navigationBarTitle("Upcoming Shows", displayMode: .inline)
            }
//        }//: NAVIGATION VIEW
//        .navigationBarHidden(true)
    }
}

// MARK:- PREVIEW

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

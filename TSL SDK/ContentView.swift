//
//  ContentView.swift
//  TSL SDK
//
//  Created by Daman Mehta on 2024-01-22.
//
import SwiftUI
import Talkshoplive

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                // SDK Initialization
                NavigationLink(destination: InitView()) {
                    Text("Initialize SDK")
                        .buttonStyle(.borderedProminent)
                        .frame(width: 240)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 4)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .navigationTitle("SDK View")
                
                // Show Class Implementation
                NavigationLink(destination: ShowView()) {
                    Text("Show View")
                        .buttonStyle(.borderedProminent)
                        .frame(width: 240)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 4)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .navigationTitle("SDK View")
                
                // Chat Class Implementation
                NavigationLink(destination: ChatView()) {
                    Text("Chat View")
                        .buttonStyle(.borderedProminent)
                        .frame(width: 240)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 4)
                        .background(Color.cyan)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .navigationTitle("SDK View")
                
                // Chat Class Implementation
                NavigationLink(destination: LiveChat()) {
                    Text("Live Chat")
                        .buttonStyle(.borderedProminent)
                        .frame(width: 240)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 4)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .navigationTitle("SDK View")
                
                // User Class Implementation
                NavigationLink(destination: UserView()) {
                    Text("User View")
                        .buttonStyle(.borderedProminent)
                        .frame(width: 240)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 4)
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
                .navigationTitle("SDK View")
            }
        }.colorScheme(.light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

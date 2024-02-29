//
//  ContentView.swift
//  TSL SDK
//
//  Created by Daman Mehta on 2024-01-22.
//
import SwiftUI
import Talkshoplive

struct ShowView: View {
    @State private var showInput: String = ""
    @State private var showResult: String = ""
    @State private var eventResult: String = ""
    @State private var eventInput: String = ""
    @State private var showObject : Talkshoplive.ShowData? = nil
    @State private var eventObject : Talkshoplive.EventData? = nil
    
    var showID = "vzzg6tNu0qOv"
    var eventID = "8WtAFFgRO1K0"
    
    var body: some View {
        ScrollView {
            VStack {
                // Link to documentation
                Link("Doc: Shows Class Usage", destination: URL(string: "https://github.com/TalkShopLive/ios-sdk?tab=readme-ov-file#shows")!)
                    .padding()
                    .foregroundColor(.blue)
                
                // Textfield
                Text("Enter Show ID")
                    .multilineTextAlignment(.leading)
                
                // Enter show ID
                TextField("Enter ID", text: $showInput)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                    .padding(.horizontal)
                    .padding(.bottom)
                    .font(.system(size: 22))
                    .onAppear {
                        // Set the initial value for idInput
                        showInput = showID
                    }
                
                // Fetch Shows
                Button("Fetch Shows") {
                    fetchShowData()
                }
                .frame(width: 240)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                
                // Fetch current event
                Button("Fetch Current Event") {
                    fetchCurrentEvent()
                }
                .frame(width: 240)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                
                // Fetch closed captions
                Button("Fetch Closed Captions") {
                    fetchClosedCaptions()
                }
                .frame(width: 240)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                
                // show.getDetails() Render result
                if (showObject?.id ?? 0) != 0 && showResult == "" {
                    VStack(alignment: .leading, spacing: 10) {
                        Spacer()
                        Text("Method: show.getDetails()")
                        Text("id: \(showObject?.id ?? 0)")
                        Text("show_key: \(showObject?.show_key ?? "")")
                        Text("name: \(showObject?.name ?? "NULL")")
                        Text("description: \(showObject?.description ?? "NULL")")
                        Text("status: \(showObject?.status ?? "NULL")")
                        Text("hls_playback_url: \(showObject?.hls_playback_url ?? "NULL")")
                        Text("hls_url: \(showObject?.hls_url ?? "NULL")")
                        Text("trailer_url: \(showObject?.trailer_url ?? "NULL")")
                        Text("air_date: \(showObject?.air_date ?? "NULL")")
                        Text("event_id: \(showObject?.event_id ?? 0)")
                    }.frame(width: 300).multilineTextAlignment(.leading)
                }
                
                // Show Error
                Text(showResult)
                    .padding()
                
                // show.getCurrentEvent() Render result
                if (eventObject?.name ?? "") != "" && eventResult == "" {
                    VStack(alignment: .leading, spacing: 10) {
                        Spacer()
                        Text("Method: show.getDetails()")
                        Text("id: \(showObject?.id ?? 0)")
                        Text("show_key: \(showObject?.show_key ?? "")")
                        Text("name: \(showObject?.name ?? "NULL")")
                        Text("description: \(showObject?.description ?? "NULL")")
                        Text("status: \(showObject?.status ?? "NULL")")
                        Text("hls_playback_url: \(showObject?.hls_playback_url ?? "NULL")")
                        Text("hls_url: \(showObject?.hls_url ?? "NULL")")
                        Text("trailer_url: \(showObject?.trailer_url ?? "NULL")")
                        Text("air_date: \(showObject?.air_date ?? "NULL")")
                        Text("event_id: \(showObject?.event_id ?? 0)")
                    }.frame(width: 300).multilineTextAlignment(.leading)
                }
                
                // Show Error
                Text(eventResult)
                    .padding()
            }
            .padding()
            .onAppear {
                initializeSDK()
            }
        }
    }
    
    func initializeSDK() {
        // Assuming SDK initialization is asynchronous
        Talkshoplive.TalkShopLive(clientKey: "sdk_2ea21de19cc8bc5e8640c7b227fef2f3", debugMode: true, testMode: true) { result in
            switch result {
            case .success:
                print("SDK Initialized Successfully")
            case .failure(let error):
                print("SDK Initialization Failed: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchShowData() {
        // Replace the API URL with your actual API endpoint
        self.showResult = showInput
        let showInstance = Talkshoplive.Show()
        self.showResult = ""
        self.eventObject = nil
        self.eventResult = ""
        showInstance.getDetails(showId: self.showID) { result in
            switch result {
                case .success(let show):
                    // Access properties of TSLShow directly
                    self.showObject = show
                    print(show)
                    // dump(show)
                case .failure(let error):
                    // Handle error case
                    self.showResult = "Error: \(error.localizedDescription)"
            }
        }
    }
    
    func fetchCurrentEvent() {
        // Replace the API URL with your actual API endpoint
        self.showResult = eventInput
        self.showInput = eventID
        let showInstance = Talkshoplive.Show()
        let showId = eventID
        self.eventResult = ""
        self.showObject = nil
        self.showResult = ""
        showInstance.getStatus(showId: showId) { result in
            switch result {
            case .success(let show):
                // Access properties of TSLShow directly
                self.eventObject = show
            case .failure(let error):
                // Handle error case
                self.eventResult = "Error: \(error.localizedDescription)"
                
            }
        }
    }
    
    func fetchClosedCaptions() {
        self.showResult = "File Name: \n\n" + (self.showObject?.cc ?? "Closed captions file not available")
    }
    
    
}

struct ShowView_Previews: PreviewProvider {
    static var previews: some View {
        ShowView()
    }
}

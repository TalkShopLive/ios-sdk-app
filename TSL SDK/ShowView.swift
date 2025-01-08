//
//  ContentView.swift
//  TSL SDK
//
//  Created by Daman Mehta on 2024-01-22.
//
import SwiftUI
import Talkshoplive

var showID = "cV_7fYBApZtS"
var eventID = "DtzLXq6CGjY-"

struct ShowView: View {
    @State private var timer: Timer?
    @State private var counter: Int = 1
    @State private var showInput: String = showID
    @State private var showResult: String = ""
    @State private var eventResult: String = ""
    @State private var eventInput: String = ""
    @State private var showObject : Talkshoplive.ShowData? = nil
    @State private var eventObject : Talkshoplive.EventData? = nil
    @State private var products : [ProductData]? = nil
    let showInstance = Talkshoplive.Show()

    
    var body: some View {
        ScrollView {
            VStack {
                // Link to documentation
                Link("Doc: Show Class Usage", destination: URL(string: "https://github.com/TalkShopLive/ios-sdk?tab=readme-ov-file#shows")!)
                    .padding()
                    .foregroundColor(.blue)
                
                // Textfield
                Text("Enter Show Key:")
                    .multilineTextAlignment(.leading)
                
                // Enter show ID
                TextField("Enter ID", text: $showInput)
                    .autocapitalization(.none)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                    .padding(.horizontal)
                    .padding(.bottom)
                    .font(.system(size: 22))
                
                Text("or autofill")
                    .multilineTextAlignment(.leading)
                HStack {
                    // Created
                    Button("Prelive") {
                        self.showInput = "q8ojABdmOBLm"
                    }
                    .frame(width: 80)
                    .padding(.vertical, 2)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(4)
                    
                    // Live
                    Button("Live") {
                        self.showInput = "DtzLXq6CGjY-"
                    }
                    .frame(width: 80)
                    .padding(.vertical, 2)
                    .foregroundColor(.black)
                    .background(Color.yellow)
                    .cornerRadius(4)
                    
                    // Finished
                    Button("Finished") {
                        self.showInput = "4Q4sk8XluBkG"
                    }
                    .frame(width: 80)
                    .padding(.vertical, 2)
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(4)
                }
                .padding(.bottom, 20)
                
                // Fetch Shows
                Button("Fetch Show") {
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
                
                // Fetch current event
                Button("Fetch Products") {
                    fetchProducts()
                }
                .frame(width: 240)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                
                // Fetch current event
                Button("Fetch Prelive Products") {
                    fetchProducts(prelive: true)
                }
                .frame(width: 240)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                
                // Start Polling
                Button(timer == nil ? "Start Polling" : "Stop Polling") {
                    if (timer == nil) {
                        startPolling()
                    } else {
                        stopPolling()
                    }
                }
                .frame(width: 240)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                
                // show.getDetails() Render result
                if (showObject?.id ?? 0) != 0 && showResult == "" && timer == nil {
                    VStack(alignment: .leading, spacing: 10) {
                        Spacer()
                        Text("Method: show.getDetails()")
                        Text("id: \(showObject?.id ?? 0)")
                        Text("showKey: \(showObject?.showKey ?? "")")
                        Text("name: \(showObject?.name ?? "NULL")")
                        Text("showDescription: \(showObject?.showDescription ?? "NULL")")
                        Text("status: \(showObject?.status ?? "NULL")")
                        Text("hlsPlaybackUrl: \(showObject?.hlsPlaybackUrl ?? "NULL")")
                        Text("hlsUrl: \(showObject?.hlsUrl ?? "NULL")")
                        Text("trailerUrl: \(showObject?.trailerUrl ?? "NULL")")
                        Text("airDate: \(showObject?.airDate ?? "NULL")")
                        Text("eventId: \(showObject?.eventId ?? 0)")
                        Text("duration: \(showObject?.duration ?? 0)")
                        Text("cc: \(showObject?.cc ?? "NULL")")
                        Text("videoThumbnailUrl: \(showObject?.videoThumbnailUrl ?? "NULL")")
                        Text("channelLogo: \(showObject?.channelLogo ?? "NULL")")
                        Text("channelName: \(showObject?.channelName ?? "NULL")")
                        Text("trailerDuration: \(showObject?.trailerDuration ?? 0)")
                        Text("inShowProductIds: \(showObject?.productsIds ?? [])")
                        Text("preliveShowProductIds: \(showObject?.entranceProductsIds ?? [])")
                        

                    }.frame(width: 300).multilineTextAlignment(.leading)
                }
                
                // Show Error
                if (showResult != "") {
                    Text(showResult)
                        .padding()
                }
                
                // show.getCurrentEvent() Render result
                if (eventObject != nil && eventResult == "") || timer != nil {
                    let eventStatus = eventObject?.status ?? showObject?.status ?? "created"
                    VStack(alignment: .leading, spacing: 10) {
                        Spacer()
                        Text("Method: show.getStatus()")
                        if (timer != nil) {
                            Text("Counter: \(+self.counter)")
                        } else {
                            Text("name: \(eventObject?.name ?? showObject?.name ?? "")")
                            Text("status: \(eventStatus)")
                            Text("duration: \(eventObject?.duration ?? 0)")
                            Text("hlsPlaybackURL: \(eventObject?.hlsPlaybackUrl ?? "")")
                            Text("hlsURL: \(eventObject?.hlsUrl ?? "NULL")")
                            Text("streamInCloud: \(eventObject?.streamInCloud ?? false ? "true" : "false")")
                            Text("totalViews: \(eventObject?.totalViews ?? 0)")

                        }
                        
                        // Polling Result
                        if (timer != nil) {
                            Text("name: \(eventObject?.name ?? showObject?.name ?? "NULL")")
                            Text("status: \(eventStatus)")
                            if (eventStatus == "created") {
                                Text("Play trailer (trailerUrl): \(showObject?.trailerUrl ?? "NULL")")
                            } else if (eventStatus == "live") {
                                Text("Show is LIVE (Use hlsPlaybackURL for streaming): \(eventObject?.hlsPlaybackUrl ?? "")")
                            } else if (eventStatus == "transcoding") {
                                Text("Transcoding - Show Transcoding text...")
                            } else if (eventStatus == "finished") {
                                Text("Show has finished - (hlsUrl for playback): \(eventObject?.hlsUrl ?? "NULL")")
                            }
                            
                            Text("streamInCloud: \(eventObject?.streamInCloud ?? false ? "true" : "false")")
                            Text("totalViews: \(eventObject?.totalViews ?? 0)")
                        }
                    }.frame(width: 300).multilineTextAlignment(.leading)
                }
                
                if self.products != nil {
                    if let products = self.products, products.count > 0 {
                        VStack(alignment: .leading, spacing: 10) {
                            Spacer()
                            Text("Method: show.getProducts()")
                            
                                ForEach(products.indices, id: \.self) { index in
                                    let product = products[index]
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("----- Product \(index) ----- \n")
                                        Text("ID: \(product.id ?? 0)")
                                        Text("SKU: \(product.sku ?? "NULL")")
                                        Text("Description: \(product.description ?? "NULL")")
                                        Text("Product Image: \(product.image ?? "NULL")")
                                        Text("Product Source: \(product.productSource ?? "NULL")")
                                        Text("Affiliate link: \(product.affiliateLink ?? "NULL")")
                                    }
                                    .padding(5)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                }
                        }
                    } else {
                        Text("No products available")
                    }

                }

                // Show Error
                if (eventResult != "") {
                    Text(eventResult)
                        .padding()
                }
            }
            .colorScheme(.light)
            .padding()
            .onAppear {
                // In live app - Do  not initialize SDK in onAppear but on app load.
                initializeSDK()
            }
            .onDisappear {
                // clear on unmount
                stopPolling()
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
        self.showResult = ""
        self.eventObject = nil
        self.eventResult = ""
        showInstance.getDetails(showKey: showInput) { result in
            switch result {
            case .success(let show):
                // Access properties of TSLShow directly
                print("\n getDetails => ", show)
                self.showObject = show
                // dump(show)
            case .failure(let error):
                // Handle error case
                if case .SHOW_NOT_FOUND = error {
                    self.showResult = "Error: \(error.localizedDescription)"
                } else {
                    self.showResult = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func fetchCurrentEvent() {
        // self.showInput = eventID
        self.eventResult = ""
        if (timer == nil) {
            self.showObject = nil
        }
        self.showResult = ""
        showInstance.getStatus(showKey: showInput) { result in
            switch result {
            case .success(let show):
                // Access properties of TSLShow directly
                self.eventObject = show
                print("===========fetchCurrentEvent=======")
                print(show)
            case .failure(let error):
                // Handle error case
                self.eventResult = "Error: \(error.localizedDescription)"
                
            }
        }
    }
    
    func fetchProducts(prelive:Bool = false) {
        self.showResult = ""
        self.showObject = nil
        self.eventObject = nil
        self.products = nil
        self.showInstance.getProducts(showKey: showInput,preLive: prelive) { result in
            switch result {
            case .success(let products):
                // Access properties of TSLShow directly
                self.products = products
                print("===========fetchProducts=======")
                
                for i in products {
//                    print("Product Details", i)
                    if let variants = i.variants, variants.count > 0 {
                        for j in variants {
//                            print("SKU", (i.sku ?? ""))
                        }
                    }
                }
            case .failure(let error):
                // Handle error case
                self.showResult = "Error: \(error.localizedDescription)"
                
            }
        }
    }
    
    // every 10 seconds
    private func startPolling() {
        fetchCurrentEvent()
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { timer in
            pollCurrentEvent()
        }
        if (showObject == nil) {
            fetchShowData()
        }
    }
    
    private func pollCurrentEvent() {
        counter = counter + 1
        if (eventObject?.status == "transcoding") {
            // Fetch show data for playback url
            fetchShowData()
        }
        fetchCurrentEvent()
    }
    
    // clear in disappear
    private func stopPolling() {
        timer?.invalidate()
        timer = nil
        counter = 1
    }
}

struct ShowView_Previews: PreviewProvider {
    static var previews: some View {
        ShowView()
    }
}

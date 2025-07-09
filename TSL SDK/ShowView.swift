//
//  ShowView.swift
//  TSL SDK
//
//  Created by Talkshoplive on 2024-01-22.
//

import SwiftUI
import Talkshoplive

let defaultShowID = "Zv4uczy8jmpi"

struct ShowView: View {
    // MARK: - State Properties
    @State private var timer: Timer?
    @State private var counter: Int = 1

    @State private var showInput: String = defaultShowID
    @State private var showResult: String = ""
    @State private var eventResult: String = ""

    @State private var showObject: Talkshoplive.ShowData?
    @State private var eventObject: Talkshoplive.EventData?
    @State private var products: [ProductData]?

    private let showInstance = Talkshoplive.Show.shared

    // MARK: - UI Body
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                documentationLink
                showKeyInputSection
                autofillButtons
                actionButtons
                showDetailsSection
                eventDetailsSection
                productListSection

                if !showResult.isEmpty {
                    Text(showResult).foregroundColor(.red)
                }

                if !eventResult.isEmpty {
                    Text(eventResult).foregroundColor(.red)
                }
            }
            .padding()
            .onAppear { initializeSDK() }
            .onDisappear { stopPolling() }
        }
        .colorScheme(.light)
    }

    // MARK: - UI Components
    private var documentationLink: some View {
        Link("Doc: Show Class Usage", destination: URL(string: "https://github.com/TalkShopLive/ios-sdk?tab=readme-ov-file#shows")!)
            .foregroundColor(.blue)
            .padding(.bottom)
    }

    private var showKeyInputSection: some View {
        VStack(alignment: .leading) {
            Text("Enter Show Key:")
            TextField("Enter ID", text: $showInput)
                .autocapitalization(.none)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
                .font(.system(size: 22))
        }
    }

    private var autofillButtons: some View {
        VStack {
            Text("or autofill")
            HStack {
                autofillButton(label: "Prelive", id: "q8ojABdmOBLm", color: .green, textColor: .white)
                autofillButton(label: "Live", id: "vzEEXz3MUF3T", color: .yellow, textColor: .black)
                autofillButton(label: "Finished", id: "4Q4sk8XluBkG", color: .red, textColor: .white)
            }
        }
    }

    private func autofillButton(label: String, id: String, color: Color, textColor: Color) -> some View {
        Button(label) { self.showInput = id }
            .frame(width: 80)
            .padding(.vertical, 4)
            .background(color)
            .foregroundColor(textColor)
            .cornerRadius(6)
    }

    private var actionButtons: some View {
        VStack(spacing: 10) {
            actionButton("Fetch Show", action: fetchShowData)
            actionButton("Fetch Current Event", action: fetchCurrentEvent)
            actionButton("Fetch Products") { fetchProducts(prelive: false) }
            actionButton("Fetch Prelive Products") { fetchProducts(prelive: true) }
            actionButton(timer == nil ? "Start Polling" : "Stop Polling") {
                timer == nil ? startPolling() : stopPolling()
            }
            actionButton("Collect - Data", action: collect)
        }
    }

    private func actionButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(title, action: action)
            .frame(width: 240)
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
    }

    private var showDetailsSection: some View {
        Group {
            if let show = showObject, show.id != 0, showResult.isEmpty, timer == nil {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Method: show.getDetails()")
                    Text("id: \(show.id ?? 0)")
                    Text("showKey: \(show.showKey ?? "")")
                    Text("name: \(show.name ?? "NULL")")
                    Text("description: \(show.showDescription ?? "NULL")")
                    Text("status: \(show.status ?? "NULL")")
                    Text("hlsPlaybackUrl: \(show.hlsPlaybackUrl ?? "NULL")")
                    Text("hlsUrl: \(show.hlsUrl ?? "NULL")")
                    Text("trailerUrl: \(show.trailerUrl ?? "NULL")")
                    Text("CC: \(show.cc ?? "NULL")")
                    Text("airDate: \(show.airDate ?? "NULL")")
                    Text("eventId: \(show.eventId ?? 0)")
                    Text("duration: \(show.duration ?? 0)")
                    Text("channelName: \(show.channelName ?? "NULL")")
                    Text("inShowProductIds: \(show.productsIds ?? [])")
                    Text("preliveShowProductIds: \(show.entranceProductsIds ?? [])")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
        }
    }

    private var eventDetailsSection: some View {
        Group {
            if eventObject != nil || timer != nil {
                let status = eventObject?.status ?? "created"
                VStack(alignment: .leading, spacing: 8) {
                    Text("Method: show.getStatus()")
                    if let event = eventObject {
                        if timer != nil {
                            Text("Counter: \(counter)")
                        }
                        Text("status: \(status)")
                        Text("duration: \(event.duration ?? 0)")
                        Text("hlsPlaybackURL: \(event.hlsPlaybackUrl ?? "")")
                        Text("hlsURL: \(event.hlsUrl ?? "NULL")")
                        Text("totalViews: \(event.totalViews ?? 0)")
                        if timer != nil {
                            if status == "created" {
                                Text("Play trailer: \(showObject?.trailerUrl ?? "NULL")")
                            } else if status == "live" {
                                Text("LIVE Stream URL: \(event.hlsPlaybackUrl ?? "NULL")")
                            } else if status == "finished" {
                                Text("Playback URL: \(event.hlsUrl ?? "NULL")")
                            } else if status == "transcoding" {
                                Text("Transcoding in progress...")
                            }
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
        }
    }

    private var productListSection: some View {
        Group {
            if let products = products, !products.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Method: show.getProducts()")
                    ForEach(products.indices, id: \.self) { index in
                        ProductItemView(product: products[index], index: index)
                    }
                }
            } else if products != nil {
                Text("No products available.")
                    .padding()
            }
        }
    }
    
    //MARK: - Views
    struct ProductItemView: View {
        let product: ProductData
        let index: Int
        
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text("----- Product \(index + 1) -----")
                Text("ID: \(product.id ?? 0)")
                Text("SKU: \(product.sku ?? "NULL")")
                Text("Description: \(product.description ?? "NULL")")
                Text("Image URL: \(product.image ?? "NULL")")
                Text("Product Source: \(product.source ?? "NULL")")
                Text("Affiliate Link: \(product.affiliateLink ?? "NULL")")
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(6)
        }
    }



    // MARK: - SDK & Data Methods
    private func initializeSDK() {
        let _ = Talkshoplive.TalkShopLive(clientKey: clientKey, debugMode: true, testMode: true) { result in
            switch result {
            case .success:
                print("✅ SDK Initialized")
            case .failure(let error):
                print("❌ SDK Initialization Failed: \(error.localizedDescription)")
            }
        }
    }

    private func fetchShowData() {
        showResult = ""
        eventObject = nil
        eventResult = ""
        showInstance.getDetails(showKey: showInput) { result in
            switch result {
            case .success(let show): self.showObject = show
            case .failure(let error): self.showResult = "Error: \(error.localizedDescription)"
            }
        }
    }

    private func fetchCurrentEvent() {
        eventResult = ""
        if timer == nil { showObject = nil }
        showResult = ""
        showInstance.getStatus(showKey: showInput) { result in
            switch result {
            case .success(let event): self.eventObject = event
            case .failure(let error): self.eventResult = "Error: \(error.localizedDescription)"
            }
        }
    }

    private func fetchProducts(prelive: Bool = false) {
        showResult = ""
        products = nil
        showInstance.getProducts(showKey: showInput, preLive: prelive) { result in
            switch result {
            case .success(let products): self.products = products
            case .failure(let error): self.showResult = "Error: \(error.localizedDescription)"
            }
        }
    }

    private func collect() {
        if let event = eventObject {
            let collector = Collect(event: event, userId: "1234")
            collector.collect(actionName: .videoPlay,videoTime: 10)
        }
    }

    private func startPolling() {
        fetchCurrentEvent()
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            self.counter += 1
            if self.eventObject?.status == "transcoding" {
                self.fetchShowData()
            }
            self.fetchCurrentEvent()
        }
        if showObject == nil {
            fetchShowData()
        }
    }

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

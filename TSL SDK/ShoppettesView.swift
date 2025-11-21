//
//  ShoppettesView.swift
//  TSL SDK
//
//  Created by Talkshoplive on 2025-10-24.
//

import SwiftUI
import Talkshoplive

struct ShoppettesView: View {
    // MARK: - State Properties
    @State private var shoppettesResult: String = ""
    @State private var channelId: String = "442" // WalmartChannelId -> Staging
    @State private var shoppettes: [ShoppettesData] = []
    @State private var shoppettesMetaData: ShoppettesMeta?
    @State private var shoppettesInstance: Shoppettes?
    @State private var isLoading = false
    
    // Page is set from API response instead of manually incrementing
    @State private var currentPage: Int = 1
    
    // MARK: - UI Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Input Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Channel ID")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            TextField("Enter Channel ID", text: $channelId)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                            
                            Button(action: {
                                currentPage = 1  // reset
                                fetchShoppettes()
                            }) {
                                HStack(spacing: 6) {
                                    if isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    } else {
                                        Image(systemName: "magnifyingglass")
                                        Text("Fetch")
                                    }
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
                                .background(channelId.isEmpty ? Color.gray.opacity(0.4) : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            .disabled(channelId.isEmpty || isLoading)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                    
                    
                    // MARK: - Shoppettes List
                    if isLoading {
                        ProgressView("Fetching shoppettes…")
                            .padding()
                        
                    } else if !shoppettes.isEmpty {
                        LazyVStack(spacing: 14) {
                            ForEach(shoppettes.indices, id: \.self) { index in
                                ShoppetteCardView(shoppette: shoppettes[index])
                            }
                        }
                        .padding(.horizontal)
                        
                        // MARK: Pagination UI using API’s next/prev
                        if let meta = shoppettesMetaData {
                            VStack(spacing: 12) {
                                
                                HStack(spacing: 20) {
                                    // PREV button
                                    Button(action: {
                                        if let prev = meta.prevPage {
                                            currentPage = prev
                                            fetchShoppettes()
                                        }
                                    }) {
                                        Text("◀ Prev")
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(meta.prevPage != nil ? Color.blue : Color.gray.opacity(0.4))
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                    .disabled(meta.prevPage == nil)
                                    
                                    
                                    // NEXT button
                                    Button(action: {
                                        if let next = meta.nextPage {
                                            currentPage = next
                                            fetchShoppettes()
                                        }
                                    }) {
                                        Text("Next ▶")
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(meta.nextPage != nil ? Color.blue : Color.gray.opacity(0.4))
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                    .disabled(meta.nextPage == nil)
                                }
                                
                                Text("Page \(currentPage)\(meta.totalPages != nil ? " / \(meta.totalPages!)" : "")")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 25)
                        }
                        
                    } else if !shoppettesResult.isEmpty {
                        Text(shoppettesResult)
                            .foregroundColor(.red)
                            .padding()
                        
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "cart.badge.questionmark")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            Text("No shoppettes available")
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 40)
                    }
                }
                .padding()
            }
            .navigationTitle("Shoppettes")
            .onAppear { initializeSDK() }
        }
    }
    
    // MARK: - Shoppette Card View
    struct ShoppetteCardView: View {
        let shoppette: ShoppettesData

        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                // MARK: - Left: Image
                AsyncImage(url: URL(string: shoppette.thumbnailUrl ?? "")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                            .opacity(0.5)
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 50, height: 100)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .clipped()

                // MARK: - Right: Info
                VStack(alignment: .leading, spacing: 6) {
                    Text(shoppette.name ?? "No Name")
                        .font(.headline)
                        .foregroundColor(.blue)

                    if let desc = shoppette.description, !desc.isEmpty {
                        Text(desc)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .lineLimit(2)
                    }

                    HStack {
                        Text("Video Status:")
                            .fontWeight(.semibold)
                        Text(shoppette.videoStatus ?? "N/A")
                        /*
                         VIDEO_STATUS_LIST = [
                         'Deleting','Deleted','Draft','Scheduled','Ready To Publish','Published','Publishing','Retrying to publish','Error Publishing','Published Without Audio','Disconnected'
                         ];
                         */
                    }
                    .font(.subheadline)

                    HStack {
                        Text("Status:")
                            .fontWeight(.semibold)
                        Text(shoppette.status ?? "N/A")
                        /*
                         VIDEO_PROCESSING_STATUS_LIST = [
                         'processing','completed','error','not_started'
                         ];
                         */
                    }
                    .font(.subheadline)
                    
                    HStack {
                        Text("Published Date:")
                            .fontWeight(.semibold)
                        Text(shoppette.publishedAt?.toFormattedDate() ?? "N/A")
                    }
                    .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.15), radius: 5, x: 0, y: 3)
        }
    }

    
    // MARK: - SDK Methods
    private func initShoppettes() {
        let token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyOTAxLCJqdGkiOiJjOTQwZTZjNTBjZTRlYWRiY2Y1ODAxNTBhNGUzZjRiOCIsImV4cCI6MTc2NTU1OTc2M30.oXZKnQA12d0gI-VTNwbtOQDDmaXwJz5GGDHydgOLNR4"
        self.shoppettesInstance = Shoppettes(jwtToken: token)
    }
    
    private func initializeSDK() {
        Talkshoplive.TalkShopLive(clientKey: clientKey, debugMode: true, testMode: true) { result in
            switch result {
            case .success:
                print("✅ SDK Initialized")
                initShoppettes()
            case .failure(let error):
                print("❌ SDK Initialization Failed: \(error.localizedDescription)")
                shoppettesResult = "SDK initialization failed: \(error.localizedDescription)"
            }
        }
    }
    
    private func fetchShoppettes() {
        shoppettesResult = ""
        shoppettes.removeAll()
        isLoading = true
        
        guard let shoppettesInstance = shoppettesInstance else {
            shoppettesResult = "Shoppettes not initialized."
            isLoading = false
            return
        }
        
        shoppettesInstance.getShoppettes(channelId: channelId, page: currentPage) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case let .success((shoppettesArray, meta)):
                    self.shoppettes = shoppettesArray
                    self.shoppettesMetaData = meta
                    self.currentPage = meta.currentPage ?? currentPage // sync from server
                    
                    if shoppettesArray.isEmpty {
                        self.shoppettesResult = "No shoppettes found for channel \(channelId)."
                    }
                    
                case .failure(let error):
                    self.shoppettesResult = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}

struct ShoppettesView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppettesView()
    }
}

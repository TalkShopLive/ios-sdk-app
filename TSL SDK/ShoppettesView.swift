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
    @State private var channelId: String = ""
    @State private var shoppettes: [ShoppetteData] = []
    @State private var shoppettesInstance: Shoppettes?
    @State private var isLoading = false

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
                            
                            Button(action: fetchShoppettes) {
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

                    // Shoppettes List
                    if isLoading {
                        ProgressView("Fetching shoppettes…")
                            .padding()
                    } else if !shoppettes.isEmpty {
                        LazyVStack(spacing: 14) {
                            ForEach(shoppettes.indices, id: \.self) { index in
                                ShoppetteCardView(shoppette: shoppettes[index], index: index)
                            }
                        }
                        .padding(.horizontal)
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

    // MARK: - Shoppette Card
    struct ShoppetteCardView: View {
        let shoppette: ShoppetteData
        let index: Int

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("Shoppette \(index + 1)")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Group {
                    HStack {
                        Text("ID:")
                            .fontWeight(.semibold)
                        Text("\(shoppette.id ?? 0)")
                    }
                    HStack {
                        Text("Name:")
                            .fontWeight(.semibold)
                        Text(shoppette.name ?? "N/A")
                    }
                    HStack {
                        Text("Description:")
                            .fontWeight(.semibold)
                        Text(shoppette.description ?? "N/A")
                    }
                    HStack {
                        Text("Status:")
                            .fontWeight(.semibold)
                        Text(shoppette.status ?? "N/A")
                    }
                    HStack {
                        Text("Video Status:")
                            .fontWeight(.semibold)
                        Text(shoppette.videoStatus ?? "N/A")
                    }
                }
                .font(.subheadline)
                .foregroundColor(.primary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
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

        shoppettesInstance.getShoppettes(channelId: channelId) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let data):
                    self.shoppettes = data
                    if data.isEmpty {
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

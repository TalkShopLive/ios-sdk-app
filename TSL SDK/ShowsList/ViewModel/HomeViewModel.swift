//
//  File.swift
//  TSL SDK
//
//  Created by Mayuri on 2024-08-08.
//

import Combine
import SwiftUI
import Talkshoplive

class HomeViewModel: ObservableObject {
    @Published var showsData: [ShowData] = []
    @Published var isLoading: Bool = false
    @Published var isSdkInitialized: Bool = false
    @Published var error: String? = nil // Optional error property

    private var cancellables = Set<AnyCancellable>()
    
    init() {
//        if self.isSdkInitialized {
//            fetchShowsData()
//        } else {
            initializeSDK()
//        }
    }
    
    func fetchShowsData() {
        guard let url = URL(string: "https://staging.cms.talkshop.live/api/s/timeline/v2/events/upcoming?page=1") else { return }
        
        isLoading = true
        error = nil
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ShowsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                case .failure(let error):
                    self.error = "Error fetching data: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }, receiveValue: { response in
                self.showsData = response.shows ?? []
                print(self.showsData.first)
                print("\n Shows fetched successfuly")
            })
            .store(in: &self.cancellables)
    }
    
    func initializeSDK() {
        // Assuming SDK initialization is asynchronous
        let _ = Talkshoplive.TalkShopLive(clientKey: "sdk_2ea21de19cc8bc5e8640c7b227fef2f3", debugMode: true, testMode: true) { result in
            switch result {
            case .success:
                print("SDK Initialized Successfully")
                DispatchQueue.main.async {
                    self.isSdkInitialized = true
                    self.fetchShowsData()
                }
            case .failure(let error):
                print("SDK Initialization Failed: \(error.localizedDescription)")
            }
        }
    }
}


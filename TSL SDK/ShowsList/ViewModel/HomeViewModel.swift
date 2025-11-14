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
    @Published var error: String? = nil // Optional error property

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchShowsData()
    }
    
    func fetchShowsData() {
        guard let url = URL(string: "https://stg.cms.talkshop.live/api/s/timeline/v2/events/upcoming?page=1") else { return }
        
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
                print("\n Shows fetched successfuly")
            })
            .store(in: &self.cancellables)
    }
}


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
    @Published var showsData: [Talkshoplive.ShowData] = []
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchShowsData()
    }
    
    func fetchShowsData() {
        guard let url = URL(string: "https://staging.cms.talkshop.live/api/s/timeline/v2/events/upcoming?page=1") else { return }
        
        isLoading = true
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [ShowData].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                case .failure(let error):
                    print("Error fetching data: \(error.localizedDescription)")
                    self.isLoading = false
                }
            }, receiveValue: { shows in
                self.showsData = shows
                print("\n Shows",shows )
            })
            .store(in: &self.cancellables)
    }
}


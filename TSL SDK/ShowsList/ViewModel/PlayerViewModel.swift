//
//  PlayerViewModel.swift
//  TSL SDK
//
//  Created by Mayuri on 2024-08-30.
//

import Foundation
import Combine
import Talkshoplive
import SwiftUI

class PlayerViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    let showInstance = Talkshoplive.Show()
    @State var showData : Talkshoplive.ShowData? = nil
    @State var eventData : Talkshoplive.EventData? = nil
    private var cancellables = Set<AnyCancellable>()
    
    func fetchCurrentEvent(showKey: String) {
        isLoading = true
        errorMessage = nil
        
        // Assuming TalkshopliveSDK has a `getStatus` function
        showInstance.getStatus(showKey: showKey) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let show):
                    // Access properties of TSLShow directly
                    self?.eventData = show
                    print("===========fetched Current Event=======")
                case .failure(let error):
                    // Handle error case
                    self?.errorMessage = "Failed to load data: \(error.localizedDescription)"
                    
                }
            }
        }
    }
    
    func fetchShowData(showKey: String) {
        isLoading = true
        errorMessage = nil
        
        showInstance.getDetails(showKey: showKey) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let show):
                    // Access properties of TSLShow directly
                    self.showData = show
                    self.fetchCurrentEvent(showKey: showKey)
                case .failure(let error):
                    // Handle error case
                    self.errorMessage = "Failed to get show details: \(error.localizedDescription)"

                }
            }
        }
    }
}

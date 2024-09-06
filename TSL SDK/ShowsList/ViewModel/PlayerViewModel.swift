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
    @Published var showData: ShowData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    let showInstance = Talkshoplive.Show()
    @State private var eventObject : Talkshoplive.EventData? = nil
    private var cancellables = Set<AnyCancellable>()
    
    func fetchShowData(showKey: String) {
        isLoading = true
        errorMessage = nil
        
        // Assuming TalkshopliveSDK has a `getStatus` function
        showInstance.getStatus(showKey: showKey) { [weak self] result in
            switch result {
            case .success(let show):
                // Access properties of TSLShow directly
                self?.eventObject = show
                print("===========fetchCurrentEvent=======")
                print(show)
            case .failure(let error):
                // Handle error case
                self?.errorMessage = "Failed to load data: \(error.localizedDescription)"
                
            }
        }
    }
}

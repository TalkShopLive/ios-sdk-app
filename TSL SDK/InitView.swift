import SwiftUI
import Talkshoplive

struct InitView: View {
    @State private var isInitialized: Bool?
    
    var body: some View {
        NavigationView {
            VStack {
                // Link to documentation
                Link("Doc: How to initialize SDK", destination: URL(string: "https://github.com/TalkShopLive/ios-sdk?tab=readme-ov-file#configure-tsl-ios-sdk")!)
                    .padding()
                    .foregroundColor(.blue)
                
                // Render Button
                Button("Initialize SDK") {
                    initializeSDK()
                }
                .frame(width: 240)
                .padding()
                .foregroundColor(.white)
                .background(Color.black)
                .cornerRadius(10)
                
                // Render "OK" or "Fail" text based on the initialization status
                if let isInitialized = isInitialized {
                    if isInitialized {
                        Text("SDK Successfully Initialized")
                            .foregroundColor(.green)
                            .font(.title)
                    } else {
                        Text("SDK Failed to Initialize")
                            .foregroundColor(.red)
                            .font(.title)
                    }
                }
                
                Spacer() // Push content to the top
            }
            .colorScheme(.light)
            .padding()
        }
    }
    
    func initializeSDK() {
        // Assuming SDK initialization is asynchronous
        Talkshoplive.TalkShopLive(clientKey: "sdk_2ea21de19cc8bc5e8640c7b227fef2f3", debugMode: true, testMode: true) { result in
            switch result {
            case .success:
                print("SDK Initialized Successfully")
                isInitialized = true
            case .failure(let error):
                print("SDK Initialization Failed: \(error.localizedDescription)")
                isInitialized = false
            }
        }
    }
}

struct InitView_Previews: PreviewProvider {
    static var previews: some View {
        InitView()
    }
}

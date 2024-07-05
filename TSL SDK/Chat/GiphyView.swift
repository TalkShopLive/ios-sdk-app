//
//  GiphyView.swift
//  TSL SDK
//
//  Created by Talkshoplive on 2024-06-03.
//

import Foundation
import GiphyUISDK
import SwiftUI


public protocol GiphyPickerDelegate: AnyObject {
    func didSelectGIF(url: URL)
    func didSelectedGifData(media: GPHMedia)
}


struct GiphyPicker: UIViewControllerRepresentable {
    
    
    weak var delegate: GiphyPickerDelegate?

    func makeUIViewController(context: UIViewControllerRepresentableContext<GiphyPicker>) -> GiphyViewController {
        Giphy.configure(apiKey:"w2cYrP7vfThDdKlcfPsHgQ26cQf6E9mg")

        let giphy = GiphyViewController()
        GiphyViewController.trayHeightMultiplier = 1.0
        giphy.swiftUIEnabled = true
        giphy.shouldLocalizeSearch = true
        giphy.dimBackground = true
        giphy.modalPresentationStyle = .currentContext
        giphy.delegate = context.coordinator
        return giphy
    }
    
    func updateUIViewController(_ uiViewController: GiphyViewController, context: UIViewControllerRepresentableContext<GiphyPicker>) {
    }
    
    //MARK:- UIViewControllerRepresentable protocol method
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, GiphyDelegate {
            var parent: GiphyPicker

            init(_ parent: GiphyPicker) {
                self.parent = parent
            }

            func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
                print("---- Giphy Data ----- ", media)
                print("\n ID => ", media.id)
                print("IMAGES => width", media.images?.original?.width )
                print("IMAGES => height", media.images?.original?.height )

                if let url = media.url(rendition: .fixedWidth, fileType: .gif) {
                    parent.delegate?.didSelectGIF(url: URL(string: url)!)
                }
                
                parent.delegate?.didSelectedGifData(media: media)
                giphyViewController.dismiss(animated: true, completion: nil)
            }

            func didDismiss(controller: GiphyViewController?) {}
        }
}

struct SheetView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button("Press to dismiss") {
            presentationMode.wrappedValue.dismiss()
        }
        .font(.title)
        .padding()
        .background(Color.black)
    }
}

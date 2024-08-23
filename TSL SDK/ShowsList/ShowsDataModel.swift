//
//  Shows.swift
//  TSL SDK
//
//  Created by Mayuri on 2024-07-30.
//

import Foundation

struct ShowsDataModel: Identifiable {
    let id = UUID()
    let name: String
    let postImage: String
    let details: String
    let status: String = "Live"
    let hlsURL: String = "https://assets-dev.talkshop.live/uploads/upcoming/2865/f0028593-ecc1-4673-8bd5-c59a70bcfde2_transcoded.mp4?orientation="
}

var ShowsData: [ShowsDataModel] = [
    ShowsDataModel(name: "Mayuri", postImage: "https://cdn-dev.talkshop.live/eyJidWNrZXQiOiJ0c2wtaW1hZ2VzLWRldmVsb3BtZW50Iiwia2V5IjoidmFyaWFudF9pbWFnZXMvMTUyNDcvb3JpZ2luYWwvd2lkZ2V0LXdpZGdldHMuanBnIiwiZWRpdHMiOnsicmVzaXplIjp7IndpZHRoIjo2MDAsImZpdCI6ImNvbnRhaW4ifX19", details: "This is a test show"),
    
    ShowsDataModel(name: "Daman", postImage: "https://cdn-dev.talkshop.live/eyJidWNrZXQiOiJ0c2wtaW1hZ2VzLWRldmVsb3BtZW50Iiwia2V5IjoidmFyaWFudF9pbWFnZXMvMTUyNDcvb3JpZ2luYWwvd2lkZ2V0LXdpZGdldHMuanBnIiwiZWRpdHMiOnsicmVzaXplIjp7IndpZHRoIjo2MDAsImZpdCI6ImNvbnRhaW4ifX19", details: "This is a second test show"),
    
    ShowsDataModel(name: "Andrea", postImage: "https://cdn-dev.talkshop.live/eyJidWNrZXQiOiJ0c2wtaW1hZ2VzLWRldmVsb3BtZW50Iiwia2V5IjoidmFyaWFudF9pbWFnZXMvMTUyNDcvb3JpZ2luYWwvd2lkZ2V0LXdpZGdldHMuanBnIiwiZWRpdHMiOnsicmVzaXplIjp7IndpZHRoIjo2MDAsImZpdCI6ImNvbnRhaW4ifX19", details: "This is a third test show"),
    
    ShowsDataModel(name: "Omyris", postImage: "https://cdn-dev.talkshop.live/eyJidWNrZXQiOiJ0c2wtaW1hZ2VzLWRldmVsb3BtZW50Iiwia2V5IjoidmFyaWFudF9pbWFnZXMvMTUyNDcvb3JpZ2luYWwvd2lkZ2V0LXdpZGdldHMuanBnIiwiZWRpdHMiOnsicmVzaXplIjp7IndpZHRoIjo2MDAsImZpdCI6ImNvbnRhaW4ifX19", details: "This is a test show"),
    
    ShowsDataModel(name: "Ali", postImage: "https://cdn-dev.talkshop.live/eyJidWNrZXQiOiJ0c2wtaW1hZ2VzLWRldmVsb3BtZW50Iiwia2V5IjoidmFyaWFudF9pbWFnZXMvMTUyNDcvb3JpZ2luYWwvd2lkZ2V0LXdpZGdldHMuanBnIiwiZWRpdHMiOnsicmVzaXplIjp7IndpZHRoIjo2MDAsImZpdCI6ImNvbnRhaW4ifX19", details: "This is a second test show"),
    
    ShowsDataModel(name: "Joel", postImage: "https://cdn-dev.talkshop.live/eyJidWNrZXQiOiJ0c2wtaW1hZ2VzLWRldmVsb3BtZW50Iiwia2V5IjoidmFyaWFudF9pbWFnZXMvMTUyNDcvb3JpZ2luYWwvd2lkZ2V0LXdpZGdldHMuanBnIiwiZWRpdHMiOnsicmVzaXplIjp7IndpZHRoIjo2MDAsImZpdCI6ImNvbnRhaW4ifX19", details: "This is a third test show"),
    
    ShowsDataModel(name: "Ikram", postImage: "https://cdn-dev.talkshop.live/eyJidWNrZXQiOiJ0c2wtaW1hZ2VzLWRldmVsb3BtZW50Iiwia2V5IjoidmFyaWFudF9pbWFnZXMvMTUyNDcvb3JpZ2luYWwvd2lkZ2V0LXdpZGdldHMuanBnIiwiZWRpdHMiOnsicmVzaXplIjp7IndpZHRoIjo2MDAsImZpdCI6ImNvbnRhaW4ifX19", details: "This is a test show"),
    
    ShowsDataModel(name: "Tushar", postImage: "https://cdn-dev.talkshop.live/eyJidWNrZXQiOiJ0c2wtaW1hZ2VzLWRldmVsb3BtZW50Iiwia2V5IjoidmFyaWFudF9pbWFnZXMvMTUyNDcvb3JpZ2luYWwvd2lkZ2V0LXdpZGdldHMuanBnIiwiZWRpdHMiOnsicmVzaXplIjp7IndpZHRoIjo2MDAsImZpdCI6ImNvbnRhaW4ifX19", details: "This is a second test show"),
    
    ShowsDataModel(name: "Andrea1", postImage: "https://cdn-dev.talkshop.live/eyJidWNrZXQiOiJ0c2wtaW1hZ2VzLWRldmVsb3BtZW50Iiwia2V5IjoidmFyaWFudF9pbWFnZXMvMTUyNDcvb3JpZ2luYWwvd2lkZ2V0LXdpZGdldHMuanBnIiwiZWRpdHMiOnsicmVzaXplIjp7IndpZHRoIjo2MDAsImZpdCI6ImNvbnRhaW4ifX19", details: "This is a third test show")
]

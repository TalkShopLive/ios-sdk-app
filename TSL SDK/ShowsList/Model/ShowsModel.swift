//
//  Shows.swift
//  TSL SDK
//
//  Created by Mayuri on 2024-07-30.
//

import Foundation
import Talkshoplive
import SwiftUI


struct ShowsResponse: Codable {
    var shows: [ShowData]?
    enum CodingKeys: String, CodingKey {
        case shows = "shows"
    }
}

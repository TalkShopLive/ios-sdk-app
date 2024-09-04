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
//    var shows: [ShowsModel]?
    var shows: [ShowData]?
    enum CodingKeys: String, CodingKey {
        case shows = "shows"
    }
}

struct ShowsModel: Codable {
    var id: Int?
    var eventKey: String?
    var type: String?
    var subType: String?
    var isPublished: Bool?
    var name: String?
    var lastEventId: Int?
    var parentScId: Int?
    var parentScKey: String?
    var isAgeRestricted: Bool?
    var streamingContent: StreamingContent?
    var master: Master?
    var owningStore: OwningStore?

    enum CodingKeys: String, CodingKey {
        case id
        case eventKey = "event_key"
        case type
        case subType = "sub_type"
        case isPublished = "is_published"
        case name
        case lastEventId = "last_event_id"
        case parentScId = "parent_sc_id"
        case parentScKey = "parent_sc_key"
        case isAgeRestricted = "is_age_restricted"
        case streamingContent = "streaming_content"
        case master
        case owningStore = "owning_store"
    }
}

struct StreamingContent: Codable {
    var id: Int?
    var availableOn: String?
    var matureContent: Bool?
    var eventIds: [Int]?
    var embedOnly: Bool?
    var spotlight: Bool?
    var pinned: Bool?
    var airDates: [String]?
    var currentEvent: CurrentEvent?

    enum CodingKeys: String, CodingKey {
        case id
        case availableOn = "available_on"
        case matureContent = "mature_content"
        case eventIds = "event_ids"
        case embedOnly = "embed_only"
        case spotlight
        case pinned
        case airDates = "air_dates"
        case currentEvent = "current_event"
    }
}

struct CurrentEvent: Codable {
    var id: Int?
    var isExpired: Bool?
    var isFeatured: Bool?
    var isTest: Bool?
    var name: String?
    var status: String?
    var vveSupported: Bool?
    var legacyChat: Bool?
    var hlsPlaybackUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case isExpired = "is_expired"
        case isFeatured = "is_featured"
        case isTest = "is_test"
        case name
        case status
        case vveSupported = "vve_supported"
        case legacyChat = "legacy_chat"
        case hlsPlaybackUrl = "hls_playback_url"
    }
}

struct Master: Codable {
    var images: [ImageAttachment]?

    enum CodingKeys: String, CodingKey {
        case images
    }
}

struct ImageAttachment: Codable {
    var attachment: ImageDetails?

    enum CodingKeys: String, CodingKey {
        case attachment
    }
}

struct ImageDetails: Codable {
    var mini: String?
    var small: String?
    var product: String?
    var large: String?
    var screen: String?
    var screenHd: String?
    var original: String?

    enum CodingKeys: String, CodingKey {
        case mini
        case small
        case product
        case large
        case screen
        case screenHd = "screen_hd"
        case original
    }
}

struct OwningStore: Codable {
    var id: Int?
    var name: String?
    var code: String?
    var image: StoreImage?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case code
        case image
    }
}

struct StoreImage: Codable {
    var id: Int?
    var attachmentWidth: Int?
    var attachmentHeight: Int?
    var attachmentFileSize: Int?
    var attachmentContentType: String?
    var attachmentFileName: String?
    var attachment: ImageDetails?
    var position: Int?
    var isDefault: Bool?
    var viewableId: Int?
    var viewableType: String?
    var isPreview: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case attachmentWidth = "attachment_width"
        case attachmentHeight = "attachment_height"
        case attachmentFileSize = "attachment_file_size"
        case attachmentContentType = "attachment_content_type"
        case attachmentFileName = "attachment_file_name"
        case attachment
        case position
        case isDefault = "is_default"
        case viewableId = "viewable_id"
        case viewableType = "viewable_type"
        case isPreview = "is_preview"
    }
}

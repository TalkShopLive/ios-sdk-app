//
//  String_Extension.swift
//  TSL SDK
//
//  Created by Talkshoplive on 2025-11-21.
//

import Foundation

public extension String {
    func toFormattedDate(format: String = "dd MMM, yyyy") -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // handle .000Z
        
        // Try parsing
        guard let date = isoFormatter.date(from: self) else {
            // Fallback: try without fractional seconds
            isoFormatter.formatOptions = [.withInternetDateTime]
            guard let fallbackDate = isoFormatter.date(from: self) else {
                return "" // could not parse
            }
            return DateFormatter.localizedString(from: fallbackDate, dateStyle: .medium, timeStyle: .none)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US")
        
        return formatter.string(from: date)
    }
}

//
//  DateFormatter+Extension.swift
//  Astropix
//
//  Created by Jignesh Raiyani on 05/03/22.
//

import Foundation
extension DateFormatter {

    /// Formats date as "yyyy-MM-dd" (e.g. 2021-12-18)
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        return formatter
    }()

    /// Formats date as "yyMMdd" (e.g. 211218)
    static let yyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMdd"
        formatter.calendar = Calendar(identifier: .iso8601)
        return formatter
    }()

    /// Formats data as "Month, Day, Year" (e.g. December 18, 2021)
    static let longDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.calendar = Calendar(identifier: .iso8601)
        return formatter
    }()
}

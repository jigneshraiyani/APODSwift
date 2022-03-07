//
//  Date+Extension.swift
//  Astropix
//
//  Created by Jignesh Raiyani on 05/03/22.
//

import Foundation
extension Date {
    /// Returns a date string as "Month Day, Year" (e.g. December 18, 2021)
    var longFormat: String {
        return DateFormatter.longDate.string(from: self)
    }

    /// Returns a date string as "yyyy-MM-dd" (e.g. 2021-12-30)
    var yyyyMMddFormat: String {
        return DateFormatter.yyyyMMdd.string(from: self)
    }

    /// Returns a date string as "yyMMdd" (e.g. 211230)
    var yyMMdd: String {
        return DateFormatter.yyMMdd.string(from: self)
    }
}

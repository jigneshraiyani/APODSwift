//
//  HTTPClient+Error.swift
//  Astropix
//
//  Created by Jignesh Raiyani on 06/03/22.
//

import Foundation

public enum NetworkErrors: Error {
    case errorParsingJSON
    case dataReturnedNil
    case returnedError(Error)
    case invalidStatusCode(Int)
    case customError(String)
}

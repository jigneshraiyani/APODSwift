//
//  PodResponse.swift
//  Astropix
//
//  Created by Jignesh Raiyani on 05/03/22.
//

import Foundation

struct PodResponse : Decodable {
    let errorMessage: String?
    let data: PodResponseData?
}

struct PodResponseData : Decodable {
    var date, explanation, title: String
    var url, mediaType, serviceVersion: String

    enum CodingKeys: String, CodingKey {
        case serviceVersion = "service_version"
        case mediaType = "media_type"
        case date, explanation, title
        case url
    }
}

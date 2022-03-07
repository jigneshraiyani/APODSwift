//
//  PodApi.swift
//  Astropix
//
//  Created by Jignesh Raiyani on 06/03/22.
//

import Foundation

struct PodApi {
    let podURL: String
    init(baseURL: String,
         path: String,
         apiKey: String,
         date:String) {
        self.podURL = "\(baseURL)\(path)?api_key=\(apiKey)&date=\(date)"
    }
}

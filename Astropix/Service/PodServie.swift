//
//  PodServie.swift
//  Astropix
//
//  Created by Jignesh Raiyani on 06/03/22.
//

import Foundation

struct PodServie {
    
    func fetchPodData(httpClient: HTTPClient,
                      requestUrl: URL,
                      completionHandler : @escaping (_ result: PodResponseData?,
                                           _ error: NetworkErrors?) -> Void) {
        httpClient.getAPIService(requestUrl: requestUrl,
                                 resultType: PodResponseData.self,
                                 completionHandler: completionHandler)
    }
    
    func downloadFile(httpClient: HTTPClient,
                      url: URL,
                      filePath: URL,
                      completionHandler: @escaping (Error?) -> Void) {
        httpClient.downloadFile(url: url,
                                toFile: filePath, completionHandler: completionHandler)
    }
}

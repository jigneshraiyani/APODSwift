//
//  HTTPClient.swift
//  Astropix
//
//  Created by Jignesh Raiyani on 05/03/22.
//

import Foundation

struct HTTPClient {
    
    func getAPIService<T:Decodable>(requestUrl: URL,
                                      resultType: T.Type,
                                    completionHandler: @escaping(_ result: T?,
                                                                 _ error: NetworkErrors?) -> Void) {
        URLSession.shared.dataTask(with: requestUrl) {
            (responseData,
             httpUrlResponse,
             error) in
            
            if(error == nil && responseData != nil && responseData?.count != 0)
            {
                //parse the responseData here
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(T.self, from: responseData!)
                    _=completionHandler(result, nil)
                }
                catch let error{
                    _=completionHandler(nil, .customError(error.localizedDescription))
                    debugPrint("error occured while decoding = \(error.localizedDescription)")
                }
            } else {
                if let error = error {
                    _=completionHandler(nil, .customError(error.localizedDescription))
                }
            }
        }.resume()
    }
    
    func downloadFile(url: URL,
                      toFile file: URL,
                      completionHandler: @escaping (Error?) -> Void) {
        
        URLSession.shared.downloadTask(with: url) {
            (tempURL,
             httpUrlResponse,
             error) in
            
            guard let tempURL = tempURL else {
                completionHandler(error)
                return
            }
            do {
                // Remove file if there is any
                if FileManager.default.fileExists(atPath: file.path) {
                    try FileManager.default.removeItem(at: file)
                }
                // Copy the tempURL to file
                try FileManager.default.copyItem(at: tempURL,
                                                 to: file)
                completionHandler(nil)
            } catch let error {
                debugPrint("error occured while decoding = \(error.localizedDescription)")
                completionHandler(error)
            }
        }.resume()
    }
    
}

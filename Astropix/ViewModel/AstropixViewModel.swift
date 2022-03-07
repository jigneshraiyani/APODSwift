//
//  AstropixViewModel.swift
//  Astropix
//
//  Created by Jignesh Raiyani on 05/03/22.
//

import Foundation
import CoreData
import UIKit

protocol AstropixViewModelDelegate {
    func didReceivePodResponse(podResponseData: PodResponseData?)
    func didFinishImageDownload(filePath: URL)
    func displayVideoData(filePath: URL)
    func displayError(error: String)
}

class AstropixViewModel {
    var delegate : AstropixViewModelDelegate?
    private let httpClient: HTTPClient
    private let podService: PodServie
    
    enum ViewModelState {
        case initiliazed
        case podrequestInProgress
        case podRequestCompleted(podResponseData: PodResponseData?)
        case imageDownloadInProgress
        case imageDownloadCompleted(filePath: URL)
        case displayVideoData(filePath: URL)
        case errorOccured(error: NetworkErrors)
    }
    
    enum MediaType: String {
        case video = "video"
        case image = "image"
        case unknown
    }
    
    var state: ViewModelState = .initiliazed {
        didSet {
            switch state {
            case .initiliazed:
                break
            case .podrequestInProgress:
                break
            case .podRequestCompleted(let podData):
                requestCompleted(podResponseData: podData)
            case .imageDownloadInProgress:
                break
            case .imageDownloadCompleted(let filePath):
                downloadCompleted(filePath: filePath)
            case .displayVideoData(let filePath):
                displayVideoData(filepath: filePath)
            case .errorOccured(let requestError):
                handleRequestError(error: requestError)
            }
        }
    }

    init(_httpClient: HTTPClient,
         _podService: PodServie) {
        httpClient = _httpClient
        podService = _podService
    }
    
    func showPodData(podRequest: PodRequest) {
        let date = podRequest.date.yyyyMMddFormat
        getPodData(date: date)
    }

    func getPodData(date: String) {
        let podApi = PodApi(baseURL: ServiceConstant.baseURL,
                            path: ServiceConstant.path,
                            apiKey: ServiceConstant.apiKey,
                            date: date)
        guard let podURL = URL(string: podApi.podURL) else { return }
        podService.fetchPodData(httpClient: httpClient,
                               requestUrl: podURL) { [weak self] podResponseData,errorData  in
            if let resonseData = podResponseData {
                self?.state = .podRequestCompleted(podResponseData: resonseData)
            }
            if let errorData = errorData {
                self?.state = .errorOccured(error: errorData)
            }
        }
    }
    
    func loadData(url: URL, completion: @escaping (URL?, Error?) -> Void) {
        // Compute a path to the URL in the cache
        let fileCachePath = FileManager.default.temporaryDirectory
            .appendingPathComponent(
                url.lastPathComponent,
                isDirectory: false
            )
        // load the image from the cache and exit
        if let _ = NSData(contentsOfFile: fileCachePath.path) {
            completion(fileCachePath, nil)
            return
        }

        podService.downloadFile(httpClient: httpClient,
                                url: url,
                                filePath: fileCachePath) { (error) in
            if let _ = NSData(contentsOfFile: fileCachePath.path) {
                completion(fileCachePath, error)
            }
        }
    }
    
    func requestCompleted(podResponseData: PodResponseData?) {
        DispatchQueue.main.async {
            self.delegate?.didReceivePodResponse(podResponseData: podResponseData)
        }
        fetchMediaData(podResponseData: podResponseData)
    }
    
    func fetchMediaData(podResponseData: PodResponseData?) {
        if let podURL = podResponseData?.url,
           let mediaType = podResponseData?.mediaType,
           let downloadURL = URL(string: podURL) {
            let downloadPodMediaType = MediaType(rawValue: mediaType) ?? .unknown
            switch downloadPodMediaType {
            case .video:
                state = .displayVideoData(filePath: downloadURL)
            case .image:
                fetchImageData(url: downloadURL)
            case .unknown:
                break
            }
        }
    }
        
    func fetchImageData(url: URL) {
        loadData(url: url) { [weak self] downloadURL, error in
            if let downloadURL = downloadURL {
                self?.state = .imageDownloadCompleted(filePath: downloadURL)
            }
        }
    }
    
    func downloadCompleted(filePath: URL) {
        DispatchQueue.main.async {
            self.delegate?.didFinishImageDownload(filePath: filePath)
        }
    }
    
    func displayVideoData(filepath: URL) {
        DispatchQueue.main.async {
            self.delegate?.displayVideoData(filePath: filepath)
        }
    }
    
    func handleRequestError(error: NetworkErrors) {
        switch error {
        case .errorParsingJSON:
            break
        case .dataReturnedNil:
            break
        case .returnedError(_):
            break
        case .invalidStatusCode(_):
            break
        case .customError(let string):
            DispatchQueue.main.async {
                self.delegate?.displayError(error: string)
            }
        }
    }
    
    func dateFromString(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        let date =  dateFormatter.date(from: date)
        return date
    }
}

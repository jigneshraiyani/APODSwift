//
//  AstropixViewController+Extension.swift
//  Astropix
//
//  Created by Jignesh Raiyani on 05/03/22.
//

import Foundation
import UIKit
import WebKit

extension AstropixViewController : AstropixViewModelDelegate {
    
    func displayVideoData(filePath: URL) {
        headerWebView.load(URLRequest(url: filePath))
        hideLoader()
    }
    
    func didFinishImageDownload(filePath: URL) {
        headerWebView.load(URLRequest(url: filePath))
        hideLoader()
    }
    
    func didReceivePodResponse(podResponseData: PodResponseData?) {
        if let explanation = podResponseData?.explanation {
            contextView.text = explanation
        }
        if let dateTitle = podResponseData?.date {
            self.navigationController?.navigationBar.topItem?.title = dateTitle
        }
        if let podTitle = podResponseData?.title {
            titleLabel.text = podTitle
        }
    }
    
    func displayError(error: String) {
        hideLoader()
        showAlert(message: error)
    }
}


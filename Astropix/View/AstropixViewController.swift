//
//  ViewController.swift
//  Astropix
//
//  Created by Jignesh Raiyani on 05/03/22.
//

import UIKit
import CoreData
import WebKit

class AstropixViewController: UIViewController {
    @IBOutlet weak var headerWebView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contextView: UITextView!
    
    lazy var datePicker: UIDatePicker = {
        let datePicker: UIDatePicker = UIDatePicker()
        
        // UIDatePicker properties
        datePicker.datePickerMode = .date
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = .clear
        return datePicker
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        var activityView = UIActivityIndicatorView(style: .large)
        return activityView
    }()
    
    private var astropixViewModel = AstropixViewModel(_httpClient: HTTPClient(),
                                                      _podService: PodServie())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.center = self.view.center
        astropixViewModel.delegate = self
        
        showWebviewConfig()
        showLoader()
        
        let podRequest = PodRequest(date: Date())
        astropixViewModel.showPodData(podRequest: podRequest)
        setDatePickerConfig()
    }
    
    @IBAction func didTapOnCalenderButton(_ sender: Any) {
        self.view.addSubview(datePicker)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        self.present(alert,
                     animated: true,
                     completion: nil)
    }
    
    func setDatePickerConfig() {
        datePicker.frame = CGRect(x: 10,
                                  y: 10,
                                  width: self.view.frame.width,
                                  height: 200)
        datePicker.addTarget(self,
                             action: #selector(datePickerValueChanged(_:)),
                             for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        showLoader()
        let podRequest = PodRequest(date: sender.date)
        astropixViewModel.showPodData(podRequest: podRequest)
        datePicker.removeFromSuperview()
    }
    
    func showLoader() {
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func hideLoader() {
        activityIndicator.stopAnimating()
    }
    
    func showWebviewConfig() {
        headerWebView.layer.cornerRadius = 10.0
        headerWebView.clipsToBounds = true
    }
}

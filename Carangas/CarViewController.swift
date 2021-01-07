//
//  CarViewController.swift
//  Carangas
//
//  Created by Eric Brito on 21/10/17.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit
import WebKit

class CarViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var lbBrand: UILabel!
    @IBOutlet weak var lbGasType: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    // MARK: - Properties
    var car: Car?

    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let car = car {
            title = car.name
            lbBrand.text = car.brand
            lbGasType.text = car.gas
            lbPrice.text = "\(String(describing: car.price))"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddEditViewController, let car = car {
            vc.car = car
        }
    }
    
    func setupWebView() {
        
        if let name = car?.name, let brand = car?.brand {
            let searchTerm = "\(name) + \(brand)".replacingOccurrences(of: " ", with: "+")
            
            let urlString = "www.google.com.br/search?q=\(searchTerm)&tbm=isch"
            
            guard let url = URL(string: urlString) else {return }

            let urlRequest = URLRequest(url: url)
            
            webView.allowsBackForwardNavigationGestures = true
            webView.allowsLinkPreview = true
            webView.navigationDelegate = self
            webView.uiDelegate = self
            webView.load(urlRequest)
        }
    }
}

extension CarViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loading.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loading.stopAnimating()
    }
}

//
//  Rest.swift
//  Carangas
//
//  Created by Thiago Antonio Ramalho on 16/12/20.
//  Copyright © 2020 Eric Brito. All rights reserved.
//

import Foundation

class Rest {
    private static let basePath = "https://carangas.herokuapp.com/cars"
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        config.httpAdditionalHeaders = ["content-type": "application/json"]
        config.timeoutIntervalForRequest = 30.0
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()
    
    private static let session = URLSession(configuration: configuration)
}

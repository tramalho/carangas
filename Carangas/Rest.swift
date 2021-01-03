//
//  Rest.swift
//  Carangas
//
//  Created by Thiago Antonio Ramalho on 16/12/20.
//  Copyright © 2020 Eric Brito. All rights reserved.
//

import Foundation

enum CarError {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
}

enum Operation {
    case save
    case update
    case delete
}

class Rest {
    private static let basePath = "https://carangas.herokuapp.com/cars"
    private static let brandPath = "https://fipeapi.appspot.com/api/1/carros/marcas.json"
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        config.httpAdditionalHeaders = ["content-type": "application/json"]
        config.timeoutIntervalForRequest = 30.0
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()
    
    private static let session = URLSession(configuration: configuration)
    
    class func loadCars(onComplete: @escaping ([Car]) -> Void, onError: @escaping (CarError) -> Void) {
        self.load(path: basePath, onComplete: onComplete, onError: onError)
    }
    
    class func loadBrands(onComplete: @escaping ([Brand]?) -> Void, onError: @escaping (CarError) -> Void) {
        self.load(path: brandPath, onComplete: onComplete, onError: onError)
    }
    
    private class func load<T:Decodable>(path: String, onComplete: @escaping (T) -> Void, onError: @escaping (CarError) -> Void) {
        guard let url = URL(string: path) else {
            onError(.url)
            return
        }
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return
                }
                
                if response.statusCode == 200 {
                    guard let data = data else {
                        onError(.noData)
                        return
                    }
                    
                    do {
                        let cars = try JSONDecoder().decode(T.self, from: data)
                        onComplete(cars)
                    } catch {
                        onError(.invalidJSON)
                        print(error.localizedDescription)
                    }
                    
                } else {
                  onError(.responseStatusCode(code: response.statusCode))
                  print("Status code \(response.statusCode)")
                }
            } else if let error = error {
                onError(.taskError(error: error))
                print(error.localizedDescription)
            }
        }
        
        dataTask.resume()
    }
    
    class func save(car: Car, onComplete: @escaping (Bool) -> Void) {
        
        var op: Operation = .save
        
        if car.id != nil {
            op = .update
        }
        
        operation(car: car, operation: op, onComplete: onComplete)
    }
    
    class func delete(car: Car, onComplete: @escaping (Bool) -> Void) {
        operation(car: car, operation: .delete, onComplete: onComplete)
    }
    
    private class func operation(car: Car, operation: Operation, onComplete: @escaping (Bool) -> Void) {
        
        var method = ""
        
        switch operation {
        case .save:
            method = "POST"
        case .update:
            method = "PUT"
        case .delete:
            method = "DELETE"
        }
        
        guard let url = URL(string: idUrl(car: car)) else {
            onComplete(false)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        
        guard let json = try? JSONEncoder().encode(car) else {
            onComplete(false)
            return
        }
        
        urlRequest.httpBody = json
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                guard let response = response as? HTTPURLResponse, response.statusCode == 200, let _ = data else {
                    onComplete(false)
                    return
                }
                onComplete(true)
            } else  {
                onComplete(false)
            }
        }
        
        dataTask.resume()
    }
    
    private class func idUrl(car: Car) -> String {
        
        var finalURL = basePath
        
        if car.id != nil {
            finalURL = basePath + "/\(String(describing: car.id))"
        }
        
        return finalURL
    }
}

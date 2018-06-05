//
//  Network.swift
//  LocApp
//
//  Created by Musa Lheureux on 30/05/2018.
//  Copyright © 2018 LocApp. All rights reserved.
//

import Foundation

class Network {
    
    static let scheme = "https"
    static let host = "jsonplaceholder.typicode.com"
    // static let host = ""
    
    enum Result<Value> {
        case success(Value)
        case failure(Error)
    }
    
    static func get(path: String, for userId: Int, completion: ((Result<Any>) -> Void)?) {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.host = self.host
        urlComponents.path = path
        let userIdItem = URLQueryItem(name: "userId", value: "\(userId)")
        urlComponents.queryItems = [userIdItem]
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            DispatchQueue.main.async {
                if let error = responseError {
                    completion?(.failure(error))
                } else if let jsonData = responseData {
                    completion?(.success(jsonData))
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                    completion?(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    static func post(jsonData: Data, path: String, completion:((Error?, Int?, Data?) -> Void)?) {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.host = self.host
        urlComponents.path = path
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
        print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                print("CLIENT ERROR : " + responseError!.localizedDescription)
                completion?(responseError!, nil, nil)
                return
            }
            
            let httpResponse = response as? HTTPURLResponse
            guard (httpResponse != nil),
                (200...299).contains(httpResponse!.statusCode) else {
                    print ("SERVER ERROR : " + String(httpResponse!.statusCode))
                    completion?(nil, httpResponse!.statusCode, nil)
                    return
            }
            
            if let data = responseData {
                completion?(nil, nil, data)
            } else {
                print("No readable data received in response")
            }
        }
        task.resume()
    }
    
    /*
    static func get(path: String) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = self.host
        urlComponents.path = path
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        let request = URLRequest(url: url)
        
        let session = URLSession.shared.dataTask(with: request , completionHandler: {(data, response, error) in
            if let jsonData = data ,
                let feed = (try? JSONSerialization.jsonObject(with: jsonData , options: .mutableContainers)) as? NSDictionary {
                
            }
        })
        session.resume()
    }
    */
    
}

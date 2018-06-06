//
//  Network.swift
//  LocApp
//
//  Created by Musa Lheureux on 30/05/2018.
//  Copyright © 2018 LocApp. All rights reserved.
//

import Foundation

class Network {
    
    static var token = UserDefaults.standard.string(forKey: "token") ?? ""

    static let scheme = "https"
    static let host = "9a18027b.ngrok.io"
    // static let host = ""

    enum Result<Value> {
        case success(Value)
        case failure(Error)
    }
    
    static func setToken(token: String) {
        self.token = token
    }
    
    static func get(path: String, for userId: Int, completion: ((Result<Data>) -> Void)?) {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.host = self.host
        urlComponents.path = path
        //let userIdItem = URLQueryItem(name: "userId", value: "\(userId)")
        //urlComponents.queryItems = [userIdItem]
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
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
    
    // #Musa
    // Usage example of this get method:
    /*
    func buttonTapped() {
     get(path: "/mypath", for: 1) { (result) in
            switch result {
            case .success(let jsonData):
                self.data = jsonData
            case .failure(let error):
                fatalError("error: \(error.localizedDescription)")
            }
        }
    }
    */
    
    static func post(path: String, jsonData: Data?, completion:((Error?, Data?) -> Void)?) {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.host = self.host
        urlComponents.path = path
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                completion?(responseError!, nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                    completion?(error, nil)
                    return
            }

            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                print("response: ", utf8Representation)
                completion?(nil, data)
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }

    // #Musa
    // Usage example of this post method:
    /*
    func buttonTapped() {
     let encoder = JSONEncoder()
     let jsonData = try encoder.encode(User)
     
     post(path: "/mypath", jsonData: jsonData) { (error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
    }
    */
    
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

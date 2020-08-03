//
//  RequestHelpers.swift
//  onTheMapProject
//
//  Created by Ivan Jovany Arellano Gaspar on 7/24/20.
//  Copyright © 2020 Ivan Jovany Arellano Gaspar. All rights reserved.
//

import Foundation

class RequestHelpers {
    
    //MARK: HELPERS FOR GET REQUEST
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, apiType: String, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if apiType == "Udacity" {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } else {
            request.addValue(Constants.ApplicationId, forHTTPHeaderField: "X-Parse-REST-API-Id")
            request.addValue(Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, error)
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                    
                }
                return
            }
            do {
                if apiType == "Udacity" {
                    let range = 5..<data.count
                    let newData = data.subdata(in: range)
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
                    DispatchQueue.main.async {
                                completion(responseObject, nil)
                            }
                } else {
                    let responseObject = try
                        JSONDecoder().decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    //MARK: Helper for POST or PUT Request
    
    class func taskForPOSTRequest<ResponseType: Decodable>(url: URL, apiType: String, responseType: ResponseType.Type, body: String,httpMethod: String, completion: @escaping (ResponseType?, Error?) -> Void)
    {
        var request = URLRequest(url: url)
        if httpMethod == "POST" {
            request.httpMethod = "POST"
        } else {
                    request.httpMethod = "PUT"
                }
                if apiType == "Udacity" {
                    request.addValue("application/json", forHTTPHeaderField: "Accept")
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                } else {
                            request.addValue("aplication/json", forHTTPHeaderField: "Content-Type")
                        }
                        request.httpBody = body.data(using: String.Encoding.utf8)
                        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                            if error != nil {
                                completion(nil, error)
                            }
                            guard let data = data else {
                                DispatchQueue.main.async {
                                    completion(nil, error)
                                }
                                return
                            }
                            do {
                                if apiType == "Udacity" {
                                    let range = 5..<data.count
                                    let newData = data.subdata(in: range)
                                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
                                    DispatchQueue.main.async {
                                        completion(responseObject, nil)
                                    }
                                } else {
                                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                                    DispatchQueue.main.async {
                                        completion(responseObject, nil)
                                    }
                                }
                            }
                            catch {
                                DispatchQueue.main.async {
                                    completion(nil, error)
                                }
                            }
                        }
                        task.resume()
                    }
                    }



//
//  FlickrClient.swift
//  VirtualTouristV1P0A
//
//  Created by Farhan Qazi on 3/31/19.
//  Copyright © 2019 Farhan Qazi. All rights reserved.
//

import Foundation

class FlickrClient {
    
    
    fileprivate init() {}
    
    // MARK:- Singleton shared instance
    
    class func sharedInstance() -> FlickrClient {
        struct Singleton {
            static let sharedInstance = FlickrClient()
        }
        return Singleton.sharedInstance
    }
    
    // MARK: - Adding Properties
    
    
    var session = URLSession.shared
    
    
    // MARK: HTTP GET Method
    
  
    
    func taskForGETMethod(_ method: String, parameters: [String: Any], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // Step 1 of 5. Setting  up the parameters
        var parametersWithKeys = parameters
        
        // Step 2 of 5. Build the URL, Configure the request
        let request = NSMutableURLRequest(url: urlFromParameters(parametersWithKeys, withPathExtension: method))
        
        // Step 3 of 5. Making the requeset
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                var userInfo = [String: Any]()
                
                userInfo[NSLocalizedDescriptionKey] = error
                userInfo[NSUnderlyingErrorKey] = error
                userInfo["http_response"] = response
                
                completionHandlerForGET(nil, NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
            }
            
            // GUARD check 1 of 3: checking for an error?
            guard (error == nil) else {
                sendError("There was an error: \(error!.localizedDescription)")
                return
            }
            
            // GUARD check 2 of 3: To check if we did get a successful 2XX response...
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            
            // GUARD check 3 of 3:  any data returned?
            guard let data = data else {
                sendError("No data was returned by the GET request!")
                return
            }
            
            // Step 4 of 5. Parse the data and use the data (happens in completion handler)
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
            // Step 5 of 5. Start the request
        task.resume()
        return task
    }
    
    // MARK: - Implementing the Helper Methods
    
    func keyInjector(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // Reassemble the JSON string
    fileprivate func JSONData(_ object: AnyObject) -> Data{
        
        var parsedResult: Any!
        do {
            parsedResult = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0))
        }
        catch {
            return Data()
        }
        
        return parsedResult as! Data
    }
    
    // Next, From raw JSON, now we return a usable  object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "converDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    
    // creation of a URL from given parameters
    private func urlFromParameters(_ parameters: [String:Any], withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        print("\(components.url!)")
        return components.url!
        
    }
    
}

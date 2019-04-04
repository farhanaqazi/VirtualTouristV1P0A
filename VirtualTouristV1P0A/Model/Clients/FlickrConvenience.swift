//
//  FlickrConvenience.swift
//  VirtualTouristV1P0A
//
//  Created by Farhan Qazi on 3/31/19.
//  Copyright © 2019 Farhan Qazi. All rights reserved.
//

import Foundation

extension FlickrClient {
    
    // MARK: - Convenience Methods
    
    func createParameters(latitude lat: Double, longitude lon: Double, page: Int) -> [String:Any] {
        
  
        let minLon = max(lon - Config.SearchBBoxHalfWidth, Config.SearchLonRange.0)
        let minLat = max(lat - Config.SearchBBoxHalfHeight, Config.SearchLatRange.0)
        let maxLon = min(lon + Config.SearchBBoxHalfWidth, Config.SearchLonRange.1)
        let maxLat = min(lat + Config.SearchBBoxHalfHeight, Config.SearchLatRange.1)
        let boundingBoxString = "\(minLon),\(minLat),\(maxLon),\(maxLat)"
        
        let parametersWithKeys: [String:Any] = [
            ParameterKeys.APIKey: Constants.ApiKey,
            ParameterKeys.BoundingBox: boundingBoxString,
            ParameterKeys.Extras: ParameterValues.MediumURL,
            ParameterKeys.Format: ParameterValues.ResponseFormat,
            ParameterKeys.HasGeo: ParameterValues.IsGeoTagged,
            ParameterKeys.Method: Methods.PhotoSearch,
            ParameterKeys.NoJSONCallback: ParameterValues.DisableJSONCallback,
            ParameterKeys.SafeSearch: ParameterValues.UseSafeSearch,
            ParameterKeys.PerPage: ParameterValues.PerPage,
            ParameterKeys.Page: page,
            ParameterKeys.Radius: Config.SearchRadius,
            ParameterKeys.GeoContext: ParameterValues.GeoContext
        ]
        
        return parametersWithKeys
    }
    
    
    func searchByLocation(latitude lat: Double, longitude lon: Double, page: Int = 1, completion: @escaping (_ results: [String: AnyObject]?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let parametersWithKeys: [String: Any] = createParameters(latitude: lat, longitude: lon, page: page)
        
        let task = taskForGETMethod("/", parameters: parametersWithKeys) { (results, error) in
            
          
            func sendError(_ code: Int, errorString: String) {
                var userInfo = [String: Any]()
                
                userInfo[NSLocalizedDescriptionKey] = errorString
                userInfo[NSUnderlyingErrorKey] = error
                userInfo["results"] = results
                
                completion(nil, NSError(domain: "searchByLocation", code: code, userInfo: userInfo))
            }
            
            if let error = error {
                sendError(error.code, errorString: error.localizedDescription)
                return
            }
            
            let results = results as! [String: AnyObject]
            
            /* GUARD: If API resulted in an Error */
            guard let stat = results[JSONResponseKeys.StatusCode] as? String , stat == JSONResponseKeys.OkStatus else {
                sendError(1, errorString: "Flickr API request returned an error.")
                return
            }
            
            completion(results, nil)
        }
        
        return task
    }
    
    
    func downloadImage( imagePath: String, completionHandler: @escaping (_ imageData: Data?, _ errorString: String?) -> Void) {
        let session = URLSession.shared
        let imgURL = NSURL(string: imagePath)
        let request: NSURLRequest = NSURLRequest(url: imgURL! as URL)
        
        let task = session.dataTask(with: request as URLRequest) {data, response, downloadError in
            
            if downloadError != nil {
                completionHandler(nil, "Could not download image \(imagePath)")
            } else {
                
                completionHandler(data, nil)
            }
        }
        
        task.resume()
    }
    
    
}


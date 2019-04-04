//
//  FlickrConstants.swift
//  VirtualTouristV1P0A
//
//  Created by Farhan Qazi on 3/31/19.
//  Copyright © 2019 Farhan Qazi. All rights reserved.
//

import Foundation
extension FlickrClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: My FLickr API Key
        static let ApiKey = "bba6b075e09c32b584ba2b3bbf4b1f6b"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "api.flickr.com"
        static let ApiPath = "/services/rest"
    }
    
    // MARK: - Config
    struct Config {
        static let SearchBBoxHalfWidth = 0.1
        static let SearchBBoxHalfHeight = 0.1
        static let SearchLatRange = (-90.0, 90.0)
        static let SearchLonRange = (-180.0, 180.0)
        static let ResponseFormat = "json"
        static let PerPage = 30
        static let SearchRadius = 5
        static let MaxPhotosReturned = Config.PerPage * 50
    }
    
    // MARK: Methods
    struct Methods {
        static let PhotoSearch = "flickr.photos.search"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let BoundingBox = "bbox"
        static let Extras = "extras"
        static let Format = "format"
        static let HasGeo = "has_geo"
        static let Media = "media"
        static let NoJSONCallback = "nojsoncallback"
        static let Page = "page"
        static let PerPage = "per_page"
        static let Radius = "radius"
        static let SafeSearch = "safe_search"
        static let Text = "text"
        static let GeoContext = "geo_context"
    }
    
    // MARK: ParameterValues
    struct ParameterValues {
        static let APIKey = Constants.ApiKey
        static let ResponseFormat = Config.ResponseFormat
        
        static let IsGeoTagged = 1
        static let NotGeoTagged = 0
        static let DisableJSONCallback = "1" // 1 = "yes"
        static let MediumURL = "url_m"
        static let UseSafeSearch = "1"
        static let PerPage = Config.PerPage
        static let MediaTypeAll = "all"
        static let MediaTypePhotos = "photos"
        static let MediaTypeVideos = "videos"
        static let GeoContext = 0 // 0 = not defined, 1 = indoors, 2 = outdoors.
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: - ResponseKeys
        static let StatusCode = "stat"
        static let Photos = "photos"
        static let OkStatus = "ok"
    }
    
    // MARK: - PhotosKeys
    struct Photos {
        static let Photo = "photo"
        static let Pages = "pages"
        static let Total = "total"
    }
    
    // MARK: - PhotoKeys
    struct Photo {
        static let Title = "title"
        static let MediumURL = "url_m"
    }
    
}



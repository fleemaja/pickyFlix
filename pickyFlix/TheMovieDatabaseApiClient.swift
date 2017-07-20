//
//  TheMovieDatabaseApiClient.swift
//  pickyFlix
//
//  Created by Drew Fleeman on 7/20/17.
//  Copyright © 2017 drew. All rights reserved.
//

import Foundation

class TheMovieDatabaseApiClient {
    
    public func getMovies(handler: @escaping (_ data: Data?, _ response: AnyObject?, _ error: String?) -> Void) {
        let url = constructURLString()
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            handler(data, response, error as? String)
        }
        task.resume()
    }
    
    func constructURLString() -> String {
        let apiUrl = "https://api.themoviedb.org/3/discover/movie"
        
        let params = [
            "api_key": TMDBapiKey,
            "language": "en-US",
            "sort_by": "popularity.desc",
            "include_video": false,
            "include_adult": false,
            "page": 1
            ] as [String : Any]
        
        let request = prepareRequest(baseUrl: "\(apiUrl)", params: params)
        return request
    }
    
    func prepareRequest(baseUrl: String, params: [String : Any]) -> String {
        let url = baseUrl + "?" + encodeParameters(params: params as [String : AnyObject])
        return url
    }
    
    func encodeParameters(params: [String: AnyObject]) -> String {
        let components = NSURLComponents()
        components.queryItems = params.map { (NSURLQueryItem(name: $0, value: String(describing: $1)) as URLQueryItem) }
        
        return components.percentEncodedQuery ?? ""
    }
    
    /*
     * Return the singleton instance of Model
     */
    class var shared: TheMovieDatabaseApiClient {
        struct Static {
            static let instance: TheMovieDatabaseApiClient = TheMovieDatabaseApiClient()
        }
        return Static.instance
    }
}

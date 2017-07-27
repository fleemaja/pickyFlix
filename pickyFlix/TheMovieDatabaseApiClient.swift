//
//  TheMovieDatabaseApiClient.swift
//  pickyFlix
//
//  Created by Drew Fleeman on 7/20/17.
//  Copyright © 2017 drew. All rights reserved.
//

import Foundation

class TheMovieDatabaseApiClient {
    
    public func getMovies(options: [String : Any], handler: @escaping (_ data: Data?, _ response: AnyObject?, _ error: String?) -> Void) {
        let url = constructURLString(options: options)
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            handler(data, response, error as? String)
        }
        task.resume()
    }
    
    public func getCastMemberId(castMember: String, handler: @escaping (_ data: Data?, _ response: AnyObject?, _ error: String?) -> Void) {
        // http://api.tmdb.org/3/search/person?api_key=KEY&query=tom%20hanks
        let baseUrl = "https://api.tmdb.org/3/search/person"
        let params = [
            "api_key": TMDBapiKey,
            "query": castMember
        ]
        let url = prepareRequest(baseUrl: "\(baseUrl)", params: params)
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            handler(data, response, error as? String)
        }
        task.resume()
    }
    
    func constructURLString(options: [String : Any]) -> String {
        let apiUrl = "https://api.themoviedb.org/3/discover/movie"
        
        let params = [
            "api_key": TMDBapiKey,
            "language": "en-US",
            "certification_country": "US",
            "certification": options["rating"] ?? "",
            "primary_release_date.gte": options["startDate"] ?? "",
            "primary_release_date.lte": options["endDate"] ?? "",
            "with_people": options["castMemberId"] ?? "",
            "sort_by": options["sortType"]!,
            "with_genres": options["genre"] ?? "",
            "vote_count.gte": 10,
            "include_video": false,
            "include_adult": false,
            "page": options["page"]!
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

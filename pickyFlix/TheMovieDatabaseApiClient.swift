//
//  TheMovieDatabaseApiClient.swift
//  pickyFlix
//
//  Created by Drew Fleeman on 7/20/17.
//  Copyright © 2017 drew. All rights reserved.
//

import Foundation

class TheMovieDatabaseApiClient {
    
    public func getMovies(page: Int, sortType: String, rating: String, startDate: String, endDate: String, genre: String, castMemberId: String, handler: @escaping (_ data: Data?, _ response: AnyObject?, _ error: String?) -> Void) {
        let url = constructURLString(page: page, sortType: sortType, rating: rating, startDate: startDate, endDate: endDate, genre: genre, castMemberId: castMemberId)
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
    
    func constructURLString(page: Int, sortType: String, rating: String, startDate: String, endDate: String, genre: String, castMemberId: String) -> String {
        let apiUrl = "https://api.themoviedb.org/3/discover/movie"
        
        let params = [
            "api_key": TMDBapiKey,
            "language": "en-US",
            "certification_country": "US",
            "certification": rating,
            "primary_release_date.gte": startDate,
            "primary_release_date.lte": endDate,
            "with_people": castMemberId,
            "sort_by": sortType,
            "with_genres": genre,
            "include_video": false,
            "include_adult": false,
            "page": page
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

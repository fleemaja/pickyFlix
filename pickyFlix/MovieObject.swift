//
//  MovieObject.swift
//  pickyFlix
//
//  Created by Drew Fleeman on 7/20/17.
//  Copyright © 2017 drew. All rights reserved.
//

import Foundation
import CoreData

class MovieObject: NSManagedObject {
    
    class func findOrCreateMovie(matching movieInfo: [String:Any], in context: NSManagedObjectContext) throws -> MovieObject {
        let request: NSFetchRequest<MovieObject> = MovieObject.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", argumentArray:["id", movieInfo["id"] as! Int32])
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                return matches[0]
            }
        } catch {
            throw error
        }
        
        // no existing movie found. create new movie
        let movie = MovieObject(context: context)
        movie.id = (movieInfo["id"] as? Int32)!
        movie.title = movieInfo["title"] as? String
        movie.year = movieInfo["year"] as? String
        movie.overview = movieInfo["overview"] as? String
        movie.rating = movieInfo["rating"] as? String
        movie.posterImage = movieInfo["posterImage"] as? NSData
        return movie
    }
    
    class func removeMovie(matching movieInfo: [String:Any], in context: NSManagedObjectContext) throws {
        let request: NSFetchRequest<MovieObject> = MovieObject.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", argumentArray:["id", movieInfo["id"] as! Int32])
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                for object in matches {
                    context.delete(object)
                }
                try? context.save()
            }
        } catch {
            throw error
        }
    }
    
}

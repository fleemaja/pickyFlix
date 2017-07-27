//
//  Genres.swift
//  pickyFlix
//
//  Created by Drew Fleeman on 7/25/17.
//  Copyright © 2017 drew. All rights reserved.
//

import Foundation

struct FilterOptions {
    let genres = [
    [
        "id": "",
        "name": "All Genres"
    ],
    [
        "id": "28",
        "name": "Action"
        ],
    [
        "id": "12",
        "name": "Adventure"
        ],
    [
        "id": "16",
        "name": "Animation"
        ],
    [
        "id": "35",
        "name": "Comedy"
        ],
    [
        "id": "80",
        "name": "Crime"
        ],
    [
        "id": "99",
        "name": "Documentary"
        ],
    [
        "id": "18",
        "name": "Drama"
        ],
    [
        "id": "10751",
        "name": "Family"
        ],
    [
        "id": "14",
        "name": "Fantasy"
        ],
    [
        "id": "36",
        "name": "History"
        ],
    [
        "id": "27",
        "name": "Horror"
        ],
    [
        "id": "10402",
        "name": "Music"
        ],
    [
        "id": "9648",
        "name": "Mystery"
        ],
    [
        "id": "10749",
        "name": "Romance"
        ],
    [
        "id": "878",
        "name": "Science Fiction"
        ],
    [
        "id": "10770",
        "name": "TV Movie"
        ],
    [
        "id": "53",
        "name": "Thriller"
        ],
    [
        "id": "10752",
        "name": "War"
        ],
    [
        "id": "37",
        "name": "Western"
        ]
    ]
    
    let sorts = [
        [
            "displayName": "Most Popular",
            "apiValue": "popularity.desc"
        ],
        [
            "displayName": "Most Revenue",
            "apiValue": "revenue.desc"
        ],
        [
            "displayName": "Most Recent",
            "apiValue": "release_date.desc"
        ],
        [
            "displayName": "Highest Rated",
            "apiValue": "vote_average.desc"
        ]
    ]
}

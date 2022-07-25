//
//  Movie.swift
//  Movies2You
//
//  Created by User on 22/07/22.
//

import Foundation

struct Movie: Codable {
    
    let original_title: String
    let popularity: Double
    let release_date: String
    let vote_count: Int
    let backdrop_path: String
    
}

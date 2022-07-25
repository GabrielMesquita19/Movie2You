//
//  Similar.swift
//  Movies2You
//
//  Created by User on 22/07/22.
//

import Foundation

struct MovieSimilar: Codable{
    let results: [Results]
}

struct Results: Codable {
    let title:String
    let release_date: String
    let backdrop_path: String
    let genre_ids: [Int]
}

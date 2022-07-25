//
//  Genres.swift
//  Movies2You
//
//  Created by User on 22/07/22.
//

import Foundation

struct Genres: Codable {
    let genres: [GenreId]
}

struct GenreId: Codable {
    let id: Int
    let name: String
}

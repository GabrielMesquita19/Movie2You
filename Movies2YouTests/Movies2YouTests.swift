//
//  Movies2YouTests.swift
//  Movies2YouTests
//
//  Created by User on 25/07/22.
//

import XCTest
@testable import Movies2You

class Movies2YouTest: XCTestCase {

    var sut = MovieViewModel()
    
    func testParseJSONShouldBeNilMovie() throws {
        let data = Data()
        let parsed = sut.parseJSON(data, "Movie")
        XCTAssertNil(parsed)
    }
    func testParseJSONShouldBeNilGenre() throws {
        let data = Data()
        let parsed = sut.parseJSON(data, "Genre")
        XCTAssertNil(parsed)
    }
    func testParseJSONShouldBeNilSimilar() throws {
        let data = Data()
        let parsed = sut.parseJSON(data, "MovieSimilar")
        XCTAssertNil(parsed)
    }
    
    
    func testParseJSONShouldNotBeNilMovie() throws {
        let stringJson = "{\"original_title\":\"Moulin Rouge\",\"popularity\":10,\"release_date\":\"2001-05-18\",\"vote_count\":5, \"backdrop_path\":\"path\"}"
        let data = stringJson.data(using: .utf8)!
        let parsed = sut.parseJSON(data, "Movie")
        XCTAssertNotNil(parsed)
    }
    func testParseJSONShouldNotBeNilGenre() throws {
        let stringJson = "{\"genres\":[{\"id\":28,\"name\":\"Action\"}]}"
        let data = stringJson.data(using: .utf8)!
        let parsed = sut.parseJSON(data, "Genre")
        XCTAssertNotNil(parsed)
    }
    func testParseJSONShouldNotBeNilSimilar() throws {
        let stringJson = "{\"results\":[{\"title\":\"Moulin Rouge\",\"release_date\":\"2001-05-18\",\"backdrop_path\":\"path\",\"genre_ids\":[10]}]}"
        let data = stringJson.data(using: .utf8)!
        let parsed = sut.parseJSON(data, "MovieSimilar")
        XCTAssertNotNil(parsed)
    }
}

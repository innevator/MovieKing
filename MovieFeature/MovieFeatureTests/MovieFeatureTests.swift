//
//  MovieFeatureTests.swift
//  MovieFeatureTests
//
//  Created by 洪宗鴻 on 2023/12/8.
//

import XCTest
import MovieFeature

struct Movie: Equatable {
    let name: String
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name
    }
}

protocol MovieService {
    func loadMovies(completion: (Result<[Movie], Error>) -> Void)
}

struct MovieAPIService: MovieService {
    let movies: [Movie]
    
    func loadMovies(completion: (Result<[Movie], Error>) -> Void) {
        completion(.success(movies))
    }
}

final class MovieFeatureTests: XCTestCase {
    
    func test_loadMovies() {
        var getMovies: [Movie] = []
        let testMovies = [Movie(name: "Movie1"), Movie(name: "Movie2")]
        let service = MovieAPIService(movies: testMovies)
        
        service.loadMovies { result in
            switch result {
            case .success(let movies):
                getMovies = movies
            case .failure(_):
                break
            }
        }
        
        XCTAssertEqual(getMovies, testMovies)
    }
}

//
//  MovieFeatureTests.swift
//  MovieFeatureTests
//
//  Created by 洪宗鴻 on 2023/12/8.
//

import XCTest
import MovieFeature

struct Movie: Hashable {
    let name: String
}

protocol MovieService {
    func loadMovies(completion: (Result<[Movie], Error>) -> Void)
}

struct MovieAPIServiceStub: MovieService {
    let testcase: (Result<[Movie], Error>)
    
    func loadMovies(completion: (Result<[Movie], Error>) -> Void) {
        completion(testcase)
    }
}

final class MovieFeatureTests: XCTestCase {
    
    func test_loadMovies_success() {
        var getMovies: [Movie] = []
        let testMovies = [Movie(name: "Movie1"), Movie(name: "Movie2")]
        let service = MovieAPIServiceStub(testcase: .success(testMovies))
        
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
    
    func test_loadMovies_failed() {
        var testError: Error?
        let error = NSError(domain: "Error", code: 0)
        let service = MovieAPIServiceStub(testcase: .failure(error))
        
        service.loadMovies { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                testError = error
            }
        }
        
        XCTAssertNotNil(testError)
    }
}

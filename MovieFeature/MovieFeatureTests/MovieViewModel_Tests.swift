//
//  MovieViewModel_Tests.swift
//  MovieFeatureTests
//
//  Created by 洪宗鴻 on 2023/12/10.
//

import XCTest
import MovieFeature

final class MovieViewModel_Tests: XCTestCase {
    
    func test_initialize() {
        let movies: [Movie] = []
        let sut = MovieViewModel(movies: movies)
        
        XCTAssertEqual(sut.movies, movies)
    }
    
    func test_sortByMovieName() {
        let testMovies = [Movie(name: "Movie1"), Movie(name: "Movie10")]
        let movies: [Movie] = testMovies + [Movie(name: "Movie2")]
        let sut = MovieViewModel(movies: movies)
        
        let newViewModel = sut.filterByName("Movie1")
        
        XCTAssertEqual(newViewModel.movies, testMovies)
    }
    
    func test_sortByMovieSource() {
        let testMovie = Movie(name: "Movie1", source: .ShowTime)
        let movies: [Movie] = [testMovie, Movie(name: "Movie2", source: .VieShow), Movie(name: "Movie3", source: .Ambassador)]
        let sut = MovieViewModel(movies: movies)
        
        let newViewModel = sut.filterBySource(.ShowTime)
        
        XCTAssertEqual(newViewModel.movies, [testMovie])
    }
}

//
//  MovieViewModel.swift
//  MovieFeature
//
//  Created by 洪宗鴻 on 2023/12/10.
//

import Foundation

public struct MovieViewModel {
    public let movies: [Movie]
    
    public init(movies: [Movie]) {
        self.movies = movies
    }
    
    public func filterByName(_ name: String) -> MovieViewModel {
        let filterMovies = movies.filter { $0.name.contains(name) }
        return MovieViewModel(movies: filterMovies)
    }
    
    public func filterBySource(_ source: Movie.SourceType)  -> MovieViewModel {
        let filterMovies =  movies.filter { $0.source == source }
        return MovieViewModel(movies: filterMovies)
    }
}

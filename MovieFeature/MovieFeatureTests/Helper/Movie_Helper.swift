//
//  Movie_Helper.swift
//  MovieFeatureTests
//
//  Created by 洪宗鴻 on 2023/12/10.
//

import MovieFeature

extension Movie {
    init(name: String) {
        self.init(name: name, imageURL: nil, source: .ShowTime)
    }
    
    init(name: String, source: Movie.SourceType) {
        self.init(name: name, imageURL: nil, source: source)
    }
}

//
//  MovieService.swift
//  MovieFeature
//
//  Created by 洪宗鴻 on 2023/12/10.
//

import Foundation

public protocol MovieService {
    func loadMovies(completion: (Result<[Movie], Error>) -> Void)
}

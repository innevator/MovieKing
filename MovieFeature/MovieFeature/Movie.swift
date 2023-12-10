//
//  Movie.swift
//  MovieFeature
//
//  Created by 洪宗鴻 on 2023/12/10.
//

import Foundation

public struct Movie: Hashable {
    public enum SourceType: String {
        case ShowTime, VieShow, Ambassador
    }
    
    public let name: String
    public let source: SourceType
    
    public init(name: String, source: SourceType) {
        self.name = name
        self.source = source
    }
}

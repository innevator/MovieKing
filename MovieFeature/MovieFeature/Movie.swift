//
//  Movie.swift
//  MovieFeature
//
//  Created by 洪宗鴻 on 2023/12/10.
//

import Foundation

public struct Movie: Hashable, Identifiable {
    public enum SourceType: String {
        case ShowTime, VieShow, Ambassador
    }
    
    public let id: String
    public let name: String
    public let source: SourceType
    public let imageURL: String?
    
    public init(name: String, imageURL: String?, source: SourceType) {
        self.id = UUID().uuidString
        self.name = name
        self.imageURL = imageURL
        self.source = source
    }
}

//
//  NetworkParams.swift
//  TopFavs
//
//  Created by Consultant on 5/13/22.
//

import Foundation

enum NetworkParams {
    case albumList
    case albumImage(path: String)
    
    var url: URL? {
        switch self { //page could be offset
        case .albumList:
            guard let urlComponents = URLComponents(string: "https://rss.applemarketingtools.com/api/v2/us/music/most-played/50/albums.json") else { return nil }
            
            return urlComponents.url
            
        case .albumImage(path: let path):
            return URL(string: "\(path)")
        }
    }
}

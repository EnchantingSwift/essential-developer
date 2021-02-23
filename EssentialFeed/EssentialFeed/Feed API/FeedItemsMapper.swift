//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Christophe Bugnon on 22/02/2021.
//

import Foundation

final class FeedItemsMapper {
    private struct Root: Decodable {
        private let items: [Item]
        var feed: [FeedItem] {
            return items.map { $0.feed }
        }
    }
    
    private struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL
        
        var feed: FeedItem {
            return FeedItem(id: id,
                            description: description,
                            location: location,
                            imageURL: image)
        }
    }
    
    private static var OK_200: Int { return 200 }

    static func map(_ data: Data, _ response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard let root = try? JSONDecoder().decode(Root.self, from: data),
              response.statusCode == OK_200 else {
            return .failure(RemoteFeedLoader.Error.invalidData)
        }
        return .success(root.feed)
    }
}

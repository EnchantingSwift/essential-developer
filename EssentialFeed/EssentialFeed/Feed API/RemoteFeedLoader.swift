//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Christophe Bugnon on 17/02/2021.
//

import Foundation

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public typealias Result = Swift.Result<[FeedItem], Error>
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success((data, response)):
                completion(FeedItemsMapper.map(data, response))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

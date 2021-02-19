//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Christophe Bugnon on 17/02/2021.
//

import Foundation

public typealias HTTPClientResult = Swift.Result<(Data, HTTPURLResponse), Error>

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

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
                guard let root = try? JSONDecoder().decode(Root.self, from: data),
                      response.statusCode == 200 else {
                    return completion(.failure(.invalidData))
                }
                completion(.success(root.items))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

private struct Root: Decodable {
    let items: [FeedItem]
}

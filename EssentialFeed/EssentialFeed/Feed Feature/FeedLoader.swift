//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Christophe Bugnon on 07/10/2020.
//

import Foundation

public typealias LoadFeedResult = Swift.Result<[FeedItem], Error>

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}

//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Christophe Bugnon on 07/10/2020.
//

import Foundation

typealias LoadFeedResult = Swift.Result<[FeedItem], Error>

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}

//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Christophe Bugnon on 07/10/2020.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}

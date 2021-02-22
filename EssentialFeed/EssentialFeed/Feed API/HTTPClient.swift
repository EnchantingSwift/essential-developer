//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Christophe Bugnon on 22/02/2021.
//

import Foundation

public typealias HTTPClientResult = Swift.Result<(Data, HTTPURLResponse), Error>

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

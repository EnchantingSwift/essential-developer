//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Christophe Bugnon on 02/03/2021.
//

import XCTest
import EssentialFeed

class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    func test_getFromURL_resumesDataTaskWithURL() {
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        let sut = URLSessionHTTPClient(session: session)
        session.stub(url: url, task: task)
        
        sut.get(from: url) { _ in }
        
        XCTAssertEqual(task.resumeCallCount, 1)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        let error = NSError(domain: "Any error", code: 0)
        session.stub(url: url, error: error)
        let sut = URLSessionHTTPClient(session: session)
        
        let exp = expectation(description: "Wait for get completion")
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError, error)
                
            default:
                XCTFail("Expect failure, got \(result) result instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private class URLSessionSpy: URLSession {
        private struct Stub {
            var task: URLSessionDataTask
            var error: Error?
        }
        
        private(set) var receivedURLs = [URL]()
        private var stubs = [URL: Stub]()
        
        override init() {}
        
        func stub(url: URL, task: URLSessionDataTask = FakeURLSessionDataTask(), error: Error? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedURLs.append(url)
            guard let stub = stubs[url] else {
                fatalError("Couldn't find stub for \(url)")
            }
            if let error = stub.error {
                completionHandler(nil, nil, error)
            }
            return stub.task
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask {
        override init() {}
    }
    
    private class URLSessionDataTaskSpy: URLSessionDataTask {
        private(set) var resumeCallCount = 0
        override init() {}
        
        override func resume() {
            resumeCallCount += 1
        }
    }
}

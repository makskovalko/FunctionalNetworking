//
//  URLSessionType.swift
//  FunctionalNetworking
//
//  Created by Maxim Kovalko on 11/14/19.
//  Copyright © 2019 Maxim Kovalko. All rights reserved.
//

import Foundation

public protocol URLSessionType {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskType
}

extension URLSession: URLSessionType {
    public func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskType {
        return dataTask(
            with: request,
            completionHandler: completionHandler
        ) as URLSessionDataTask
    }
}

public protocol URLSessionDataTaskType {
    func resume()
    func cancel()
    func suspend()
}

extension URLSessionDataTask: URLSessionDataTaskType {}

//
//  APIRoutable.swift
//  FunctionalNetworking
//
//  Created by Maxim Kovalko on 11/14/19.
//  Copyright © 2019 Maxim Kovalko. All rights reserved.
//

import Foundation

public protocol APIRoutable {
    var timeoutSeconds: Int { get }
    var httpMethod: Http.Method { get }
    var headers: Http.Parameters { get }
    var uriParameters: Http.Parameters { get }
    var priority: Int { get }
    
    var url: URL? { get }
    var requireAuth: Bool { get }
}

public extension APIRoutable {
    var timeoutSeconds: Int { return 30 }
    var httpMethod: Http.Method { .post }
    var headers: Http.Parameters { return [:] }
    var uriParameters: Http.Parameters { return [:] }
    var priority: Int { return 1 }
}

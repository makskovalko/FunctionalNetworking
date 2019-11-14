//
//  Network.swift
//  FunctionalNetworking
//
//  Created by Maxim Kovalko on 11/14/19.
//  Copyright © 2019 Maxim Kovalko. All rights reserved.
//

import Foundation

public enum Http {
    public typealias Parameters = [String: String]
    
    public enum Method: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
        case put = "PUT"
        case patch = "PATCH"
    }
}

public extension Http {
    struct Request<DataType: Encodable> {
        public let method: Http.Method
        public let url: URL?
        public let jsonObject: DataType
        public let headers: Http.Parameters
    }
    
    struct Credentials {
        public let authDetails: AuthDetails
        public let deviceCode: String
    }
    
    struct AuthDetails: Codable {
        public let contentType: String
        public let applicationId: String
        public let clientPublicId: String
        public let clientSecretKey: String
        public let subApplicationName: String
        public let accessToken: String
        
        public init(
            contentType: String,
            applicationId: String,
            clientPublicId: String,
            clientSecretKey: String,
            subApplicationName: String,
            accessToken: String
        ) {
            self.contentType = contentType
            self.applicationId = applicationId
            self.clientPublicId = clientPublicId
            self.clientSecretKey = clientSecretKey
            self.subApplicationName = subApplicationName
            self.accessToken = accessToken
        }
        
        private enum CodingKeys: String, CodingKey {
            case contentType = "Content-Type"
            case applicationId = "application-id"
            case clientPublicId = "client-public-id"
            case clientSecretKey = "client-secret-key"
            case subApplicationName = "sub-application-name"
            case accessToken = "Authorization"
        }
    }
}

public enum NetworkError: Error {
    case invalidURL
    case noConnection
    case noAuthorizationData
    case noAccountCode
}

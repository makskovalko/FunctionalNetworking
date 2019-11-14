//
//  NetworkFunctions.swift
//  FunctionalNetworking
//
//  Created by Maxim Kovalko on 11/14/19.
//  Copyright © 2019 Maxim Kovalko. All rights reserved.
//

import RxSwift
import RxCocoa

// MARK: - Functions for network components transformations

enum F {
    enum Network {}
}

// MARK: - Add headers for request

extension F.Network {
    static func addHeaders<Request>(
        forRoute route: APIRoutable,
        auth: Http.AuthDetails?,
        request: Request
    ) -> (APIRoutable, Http.Parameters, Request) where Request: Encodable {
        let headers: Http.Parameters = {
            switch auth {
                case .some(let authData) where route.requireAuth:
                    return route.headers
                        + authData
                            .dictionary
                            .mapValues { $0 as? String ?? "" }
                default:
                    return route.headers
            }
        }()
        return (route, headers, request)
    }
}

// MARK: - Create request for route

extension F.Network {
    static func createRequest<Request>(
        forRoute route: APIRoutable,
        headers: Http.Parameters,
        request: Request
    ) -> Http.Request<Request> where Request: Encodable {
        return Http.Request(
            method: route.httpMethod,
            url: route.url,
            jsonObject: request,
            headers: headers
        )
    }
}

// MARK: - Convert request to URLRequest

extension F.Network {
    static func convertToUrlRequest<Request>(request: Http.Request<Request>)
        -> URLRequest where Request: Encodable {
            guard let url = request.url else { fatalError("Invalid URL address") }
            var urlRequest = URLRequest(url: url)
            urlRequest.allHTTPHeaderFields = request.headers
            urlRequest.httpMethod = request.method.rawValue
            if request.method != .get {
                urlRequest.httpBody = try? JSONEncoder().encode(request.jsonObject)
            }
            return urlRequest
    }
}

// MARK: - Execute URLRequest

extension F.Network {
    static func execute<Response>(
        request: URLRequest,
        session: URLSessionType
    ) -> Observable<Response> where Response: Decodable {
        return Observable<Response>.create { observer in
            let task = session.dataTask(with: request) { data, response, error in
                (observer, data, response, error) |> self.parseResponse
            }
            task.resume()
            return Disposables.create(with: task.cancel)
        }
    }
}

// MARK: - Parse response

private extension F.Network {
    static func parseResponse<Response>(
        observer: AnyObserver<Response>,
        data: Data?,
        response: URLResponse?,
        error: Error?
    ) where Response: Decodable {
        switch (data, error) {
            case (.some(let data), nil):
                let response = try? JSONDecoder().decode(
                    Response.self,
                    from: data
                )
                response.map(observer.onNext)
            case (nil, .some(let error)):
                observer.onError(error)
            default: break
        }
        observer.onCompleted()
    }
}


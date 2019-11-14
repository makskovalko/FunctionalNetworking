//
//  RestClient.swift
//  FunctionalNetworking
//
//  Created by Maxim Kovalko on 11/14/19.
//  Copyright © 2019 Maxim Kovalko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol IRestClient {
    func executeRequest<Request, Response>(route: APIRoutable, request: Request)
        -> Observable<Response> where Request: Encodable, Response: Decodable
    
    func executeRequest<Response>(route: APIRoutable)
        -> Observable<Response> where Response: Decodable
}

public final class RestClient {
    private let authProvider: AuthProviding
    private let connectivityService: ConnectivityServiceType
    private let session: URLSessionType
    
    private var authDetails: Http.AuthDetails? = nil
    private var isConnected = false
    
    private let disposeBag = DisposeBag()
    
    public init(
        authProvider: AuthProviding,
        connectivityService: ConnectivityServiceType,
        session: URLSessionType
    ) {
        self.authProvider = authProvider
        self.connectivityService = connectivityService
        self.session = session
        
        self.authProvider
            .authDetails
            .subscribe(onNext: onAuthDetailsChanged)
            .disposed(by: disposeBag)
        
        self.connectivityService
            .observe()
            .subscribe(onNext: onConnectivityStatusChanged)
            .disposed(by: disposeBag)
    }
}

// MARK: - Execute API Request

extension RestClient: IRestClient {
    public func executeRequest<Request: Encodable, Response: Decodable>(
        route: APIRoutable,
        request: Request
    ) -> Observable<Response> {
        guard isConnected else { return .error(NetworkError.noConnection) }
        
        return (route, authDetails, request)
            |> F.Network.addHeaders
            |> F.Network.createRequest
            |> F.Network.convertToUrlRequest
            |> { ($0, self.session) |> F.Network.execute }
    }
    
    public func executeRequest<Response: Decodable>(route: APIRoutable) -> Observable<Response> {
        guard isConnected else { return .error(NetworkError.noConnection) }
        
        return (route, authDetails, Empty())
            |> F.Network.addHeaders
            |> F.Network.createRequest
            |> F.Network.convertToUrlRequest
            |> { ($0, self.session) |> F.Network.execute }
    }
}

// MARK: - Auth and Connectivity Handlers

private extension RestClient {
    func onAuthDetailsChanged(_ authDetails: Http.AuthDetails) {
        self.authDetails = authDetails
    }
    
    func onConnectivityStatusChanged(_ isConnected: Bool) {
        self.isConnected = isConnected
    }
}

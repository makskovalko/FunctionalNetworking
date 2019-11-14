//
//  AuthProvider.swift
//  FunctionalNetworking
//
//  Created by Maxim Kovalko on 11/14/19.
//  Copyright © 2019 Maxim Kovalko. All rights reserved.
//

import RxSwift

public protocol AuthProviding {
    var authDetails: Observable<Http.AuthDetails> { get }
}

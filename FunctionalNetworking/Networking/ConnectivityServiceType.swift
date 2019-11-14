//
//  ConnectivityServiceType.swift
//  FunctionalNetworking
//
//  Created by Maxim Kovalko on 11/14/19.
//  Copyright © 2019 Maxim Kovalko. All rights reserved.
//

import RxSwift

public protocol ConnectivityServiceType {
    func observe() -> Observable<Bool>
}

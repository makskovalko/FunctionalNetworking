//
//  Encodable+Extension.swift
//  FunctionalNetworking
//
//  Created by Maxim Kovalko on 11/14/19.
//  Copyright © 2019 Maxim Kovalko. All rights reserved.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        let json = try? JSONSerialization.jsonObject(
            with: data,
            options: .allowFragments
        )
        return json.flatMap { $0 as? [String: Any] } ?? [:]
  }
}

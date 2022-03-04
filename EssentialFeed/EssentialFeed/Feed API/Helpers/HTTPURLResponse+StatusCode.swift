//
//  HTTPURLResponse+StatusCode.swift
//  EssentialFeed
//
//  Created by Hitesh on 14/02/22.
//

import Foundation

public extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return self.statusCode == HTTPURLResponse.OK_200
    }
}

//
//  Dapp.swift
//

import Foundation

public struct AppMetadata {
    public let name: String
    public let url: String
    var platform: String = "ios"

    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

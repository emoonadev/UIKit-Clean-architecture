//
// Created by Mickael Belhassen on 27/03/2022.
//

import Foundation

struct Name: Equatable, Codable, RawRepresentable {
    var rawValue: String

    init?(rawValue: String) {
        guard !rawValue.isEmpty else { return nil }
        self.rawValue = rawValue
    }

    init(_ rawValue: String) throws {
        guard !rawValue.isEmpty else { throw TDError.invalidName }
        self.rawValue = rawValue
    }

    func callAsFunction() -> String { rawValue }
}
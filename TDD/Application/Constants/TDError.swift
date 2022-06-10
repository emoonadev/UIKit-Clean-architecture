//
// Created by Mickael Belhassen on 16/03/2022.
//

import Foundation

enum TDError: Error {
    case invalidName
    case somethingWrong
    case none
    case customError(description: String, responseCode: Int)
}

extension TDError: LocalizedError {

    var errorDescription: String? {
        switch self {
            case .invalidName:
                return NSLocalizedString("Filled name invalid", comment: "Filled name invalid")
            case .somethingWrong:
                return NSLocalizedString("Something went wrong", comment: "Something went wrong")
            case .customError(let desc, let code):
                return NSLocalizedString(desc, comment: desc)
            default:
                return nil
        }
    }

    var errorCode: Int? {
        switch self {
            case .invalidName, .somethingWrong: return -1
            case .customError(let _, let code): return code
            default: return nil
        }
    }

}
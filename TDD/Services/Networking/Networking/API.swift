//
// Created by Mickael Belhassen on 21/03/2022.
//

import Foundation

protocol APIService {
    func perform<T: Decodable>(_ route: APIConstants.Route) async throws -> T
    func perform(_ route: APIConstants.Route) async throws
}

final class API: APIService {
    let networking: NetworkingService

    init(networking: NetworkingService) {
        self.networking = networking
    }
}

// MARK: - Perform request

extension API {

    func perform<T: Decodable>(_ route: APIConstants.Route) async throws -> T {
        let req = route.request

        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<T, Error>) in
            networking.request(url: req.url, method: req.method, headers: req.headers, body: req.body) { (response: URLResponse?, result: Result<T, Error>) in
                switch result {
                    case .success(let response):
                        continuation.resume(returning: response)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                }
            }
        }
    }

    func perform(_ route: APIConstants.Route) async throws {
        let req = route.request

        return try await withUnsafeThrowingContinuation { (continuation: UnsafeContinuation<Void, Error>) in
            networking.request(url: req.url, method: req.method, headers: req.headers, body: req.body) { (response: URLResponse?, result: Result<Nothing, Error>) in
                switch result {
                case .success(_):
                        continuation.resume(returning: ())
                    case .failure(let error):
                        continuation.resume(throwing: error)
                }
            }
        }
    }
}

struct Nothing: Codable {}

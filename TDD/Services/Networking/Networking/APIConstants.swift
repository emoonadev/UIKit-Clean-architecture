//
// Created by Mickael Belhassen on 21/03/2022.
//

import Foundation

struct APIConstants {
    static let baseURL = URL(string: "https://623822fc0a54d2ceab71233a.mockapi.io/")!

    struct Request {
        var url: URL
        var headers: [String: String]?
        var body: [String: Any]?
        var method: HTTPMethod = .post
    }

    enum Route {
        case getCustomers
        case getPosts
        case addCustomer(Customer)

        var request: Request {
            var request = Request(url: baseURL, headers: ["Content-Type": "application/json"], body: nil)

            switch self {
                case .getCustomers: get(.customers)
                case .getPosts: get(.posts)
                case .addCustomer(let customer): post(.customers, body: customer)
            }

            func get(_ path: BTPath...) {
                buildPath(.get, pathComponent: path)
            }

            func delete(_ path: BTPath...) {
                buildPath(.delete, pathComponent: path)
            }

            func put<T: Codable>(_ path: BTPath..., body: T) {
                buildPath(.put, pathComponent: path)
                request.body = try? DictionaryEncoder.encode(body)
            }

            func post<T: Codable>(_ path: BTPath..., body: T) {
                buildPath(.post, pathComponent: path)
                request.body = try? DictionaryEncoder.encode(body)
            }

            func buildPath(_ method: HTTPMethod, pathComponent: [BTPath]) {
                pathComponent.forEach { request.url.appendPathComponent($0.path) }
                request.method = method
            }

            return request
        }
    }
}

// MARK: - Paths

extension BTPath {
    static let customers: BTPath = "customers"
    static let posts: BTPath = "posts"
}


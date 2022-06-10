//
// Created by Mickael Belhassen on 21/03/2022.
//

import Foundation
@testable import TDD

class MockNetworking: NetworkingService {
    var JSONResponse: String?
    var responseCode: Int = 200

    var handleCustomErrors: ((Int, String) -> Error)? = nil

    func request<T: Decodable>(url: URL, method: HTTPMethod, headers: [String: String]?, queryItems: [URLQueryItem]?, body: [String: Any]?, completion: @escaping (URLResponse?, Result<T, Error>) -> ()) {
        if let JSONResponse = JSONResponse {
            if responseCode == 200 {
                do {
                    let values = try JSONDecoder().decode(T.self, from: JSONResponse.data(using: .utf8)!)
                    completion(nil, .success(values))
                } catch {
                    completion(nil, .failure(error))
                }
            } else {
                completion(nil, .failure(TDError.somethingWrong))
            }
        } else {
            if responseCode == 200 {
                completion(nil, .success(Nothing() as! T))
            } else {
                completion(nil, .failure(TDError.somethingWrong))
            }
        }
    }

}

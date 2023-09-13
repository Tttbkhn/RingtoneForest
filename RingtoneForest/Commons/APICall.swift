//
//  APICall.swift
//  RingtoneForest
//
//  Created by Thu Truong on 9/13/23.
//

import Foundation

protocol APICall {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    func body() throws -> Data?
}

enum APIError: Error, Equatable {
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        return lhs.errorDescription == rhs.errorDescription
    }
    
    case invalidURL
    case httpCode(HTTPCode)
    case expiredToken
    case error(ErrorResponse)
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case let .httpCode(code): return "Unexpected HTTP Code: \(code)"
        case .expiredToken: return "Token expired"
        case let .error(error): return error.message
        }
    }
}

extension APICall {
    func urlRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = try body()
        return request
    }
}

extension URLRequest {
    func debugRequest() -> URLRequest {
        print("Debug")
        return self
    }
}

struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    static let get = HTTPMethod(rawValue: "GET")
    static let post = HTTPMethod(rawValue: "POST")
    
    let rawValue: String
    init(rawValue: String) {
        self.rawValue = rawValue
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200..<300
}

typealias Parameters = [String: Any]

public let kRetryRequest = 3

struct ErrorResponse: Codable {
    let statusCode: Int
    let message: String
}

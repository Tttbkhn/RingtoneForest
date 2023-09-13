//
//  WebRepository.swift
//  RingtoneForest
//
//  Created by Thu Truong on 9/13/23.
//

import Foundation
import Combine

protocol WebRepository {
    var session: URLSession { get }
}

extension WebRepository {
    func call<Value>(endpoint: APICall, token: String = TokenLDS().get(key: Constant.kTokenCache), triesLeft: Int = 3) -> AnyPublisher<Value, Error> where Value: Decodable {
        func publisher(forDataTaskOutput output: URLSession.DataTaskPublisher.Output) -> AnyPublisher<Value, Error> {
            switch (output.response as? HTTPURLResponse)?.statusCode {
            case .some(200..<300):
                return Result<JSONDecoder.Input, APIError>.success(output.data).publisher
                    .decode(type: Value.self, decoder: JSONDecoder())
                    .receive(on: DispatchQueue.main)
                    .eraseToAnyPublisher()
            case .some(401) where triesLeft > 1, .some(403) where triesLeft > 1, .some(410) where triesLeft > 1:
                return refreshToken()
                    .flatMap { token in
                        return call(endpoint: endpoint, token: token, triesLeft: triesLeft - 1) }
                    .eraseToAnyPublisher()
            default:
                let decoder = JSONDecoder()
                if let error = try? decoder.decode(ErrorResponse.self, from: output.data) {
                    return Fail(error: APIError.error(error)).eraseToAnyPublisher()
                }
                return Fail(error: APIError.httpCode((output.response as? HTTPURLResponse)?.statusCode ?? 0)).eraseToAnyPublisher()
            }
        }
        
        do {
            let request = try endpoint.urlRequest().debugRequest()
            return URLSession.shared.dataTaskPublisher(for: request)
                .mapError { $0 as Error }
                .retry(kRetryRequest)
                .flatMap(publisher(forDataTaskOutput:))
                .eraseToAnyPublisher()
        } catch let error {
            return Fail<Value, Error>(error: error).eraseToAnyPublisher()
        }
    }
    
    func refreshToken() -> AnyPublisher<String, Error> {
            let tokenLDS = TokenLDS()
            
            let url = URL(string: "http://164.90.157.54/api/client/get-token/phamtienmanh0585@gmail.com")!
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .mapError { $0 as Error }
                .map({ data, response in
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 422 {
                        print("User expired after 30 days")
                    }
                    
                    return data
                })
                .decode(type: WallpaperToken.self, decoder: JSONDecoder())
                .map {
                    tokenLDS.cache(value: $0.data, key: Constant.kTokenCache)
                    return $0.data
                }
                .eraseToAnyPublisher()
        }
}

private extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func requestJSON<Value>() -> AnyPublisher<Value, Error> where Value: Decodable {
        return tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                let decoder = JSONDecoder()
                if let error = try? decoder.decode(ErrorResponse.self, from: data) {
                    throw APIError.error(error)
                }
                
                switch (response as! HTTPURLResponse).statusCode {
                case 403:
                    throw APIError.expiredToken
                default:
                    throw APIError.httpCode((response as! HTTPURLResponse).statusCode)
                    
                }
            }
            
            return data
        }
        .extractUnderlyingError()
        .decode(type: Value.self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

extension Publisher {
    func sinkToResult(_ result: @escaping (Result<Output, Failure>) -> Void) -> AnyCancellable {
        return sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error):
                result(.failure(error))
            default: break
            }
        }, receiveValue: { value in
            result(.success(value))
        })
    }
    
    func extractUnderlyingError() -> Publishers.MapError<Self, Failure> {
        mapError {
            ($0.underlyingError as? Failure) ?? $0
        }
    }
}

private extension Error {
    var underlyingError: Error? {
        let nsError = self as NSError
        if nsError.domain == NSURLErrorDomain && nsError.code == -1009 {
            // "The Internet connection appears to be offline."
            return self
        }
        return nsError.userInfo[NSUnderlyingErrorKey] as? Error
    }
}

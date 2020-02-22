//
//  DataLoader.swift
//  LRUCacheDemo
//
//  Created by 倪僑德 on 2020/2/16.
//  Copyright © 2020 Aaron_Ni. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case invalidURL
    case unknown(Error?)
    case wrongFormat(Error?)
    case noResponseData
}

final class DataLoader {
    
    public func request<Model: Decodable>(type: Model.Type,
                                          endpoint: Endpoint,
                                          then handler: @escaping(Result<Model, ApiError>) -> Void) {
        
        guard let url = endpoint.url else {
            return handler(.failure(.invalidURL))
        }
        
        // Cache
        if let cacheData = APICacheManager.shared.getCache(by: endpoint),
            let model = try? encode(Model.self, from: cacheData) {
            return handler(.success(model))
        }
        
        // Setup Request
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        request.httpBody = endpoint.getHttpBody()
        
        if let headers = endpoint.httpHeaders {
            headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                guard let data = data else {
                    return handler(.failure(.noResponseData))
                }
                let model = try self.encode(Model.self, from: data)
                APICacheManager.shared.setCache(with: endpoint, data: data)
                
                handler(.success(model))
            } catch {
                handler(.failure(.wrongFormat(error)))
            }
        }
        task.resume()
    }
}

extension DataLoader {
    
    private func encode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw ApiError.wrongFormat(error)
        }
    }
}

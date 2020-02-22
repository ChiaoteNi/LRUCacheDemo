//
//  APICacheManager.swift
//  LRUCacheDemo
//
//  Created by 倪僑德 on 2020/2/16.
//  Copyright © 2020 Aaron_Ni. All rights reserved.
//

import Foundation

final class APICacheManager {
    
    static let shared: APICacheManager = .init()
    
    private(set) var caches: LRUCache<String, Data> = .init(maxCacheSize: 5)
    
    func setCache(with endpoint: Endpoint, data: Data) {
        guard let cacheKey = getCacheKey(of: endpoint) else { return }
        caches.setCache(key: cacheKey, value: data)
    }
    
    func getCache(by endpoint: Endpoint) -> Data? {
        guard let cacheKey = getCacheKey(of: endpoint) else { return nil }
        return caches.getCache(key: cacheKey)
    }
    
    func removeCache(of endpoint: Endpoint) {
        guard let cacheKey = getCacheKey(of: endpoint) else { return }
        caches.removeCache(of: cacheKey)
    }
    
    private func getCacheKey(of endpoint: Endpoint) -> String? {
        
        switch endpoint.httpMethod {
        case .get, .delete:
            return endpoint.url?.absoluteString
            
        case .post, .put:
            guard let parameters = endpoint.parameters
                , var urlString = endpoint.url?.absoluteString else { return nil }

            parameters.forEach({ element in
                urlString += "\(element.key)=\(element.value)&"
            })
            
            return urlString
        }
    }
}


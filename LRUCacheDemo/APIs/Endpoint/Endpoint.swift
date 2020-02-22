//
//  Endpoint.swift
//  LRUCacheDemo
//
//  Created by 倪僑德 on 2020/2/16.
//  Copyright © 2020 Aaron_Ni. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct Endpoint {
    private var scheme: String
    private var host: String
    private var path: String
    private var port: Int?
    
    private(set) var httpMethod: HttpMethod
    private(set) var httpHeaders: [String: String]?
    private(set) var parameters: [String: Any]?
    
    private(set) var url: URL?
    
    init(scheme: String = "http",
         host: String,
         path: String,
         port: Int? = nil,
         httpMethod: HttpMethod,
         httpHeaders: [String: String]? = nil,
         parameters: [String: Any]? = nil) {
        
        self.scheme = scheme
        self.host = host
        self.path = path
        self.port = port
        self.httpMethod = httpMethod
        self.httpHeaders = httpHeaders
        self.parameters = parameters
        
        self.url = getURL()
    }
    
    func getHttpBody() -> Data? {
        switch httpMethod {
        case .get, .delete:
            return nil
        case .post, .put:
            guard let parameters = parameters else { return nil }
            return getData(with: parameters)
        }
    }
}

extension Endpoint {
    
    private func getURL() -> URL? {
        var component: URLComponents = .init()
        component.scheme = scheme
        component.host = host
        component.path = path
        component.port = port
        
        switch httpMethod {
        case .get, .delete:
            component.queryItems = getQuiryItems(with: parameters)
        case .post, .put:
            break
        }
        return component.url
    }
    
    private func getQuiryItems(with parameters: [String: Any]?) -> [URLQueryItem]? {
        guard let parameters = parameters else { return nil }
        
        let items: [URLQueryItem] = parameters.compactMap({ key, value in
            return URLQueryItem.init(name: key, value: "\(value)")
        })
        return items
    }
    
    private func getData(with dic: [String: Any]) -> Data? {
        var text = ""
        dic.forEach({
           text += "\($0.key)=\($0.value)&"
        })
        text.removeLast()
        return text.data(using: .utf8)
    }
}

//
//  Endpoint + App.swift
//  LRUCacheDemo
//
//  Created by 倪僑德 on 2020/2/17.
//  Copyright © 2020 Aaron_Ni. All rights reserved.
//

import Foundation

extension Endpoint {
    
    static func demo(waitTime: Int) -> Endpoint {
        return .init(scheme: "http",
                     host: "chiaoni3145951.com",
                     path: "/ApiTest/CacheDemoApi.php",
                     httpMethod: .get,
                     httpHeaders: nil,
                     parameters: ["wait": waitTime])
    }
}

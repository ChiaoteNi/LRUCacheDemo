//
//  API.swift
//  LRUCacheDemo
//
//  Created by 倪僑德 on 2020/2/17.
//  Copyright © 2020 Aaron_Ni. All rights reserved.
//

import Foundation

class DemoAPI {
    
    private static var dataloader: DataLoader = .init()
    
    static func cacheDemo(waitTime: Int,
                          then handler: @escaping (Result<String, ApiError>)->Void) {
        
        dataloader.request(type: SimpleResponseModel.self,
                           endpoint: .demo(waitTime: waitTime)) { result in
                            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    handler(.success(response.result))
                case .failure(let error):
                    handler(.failure(error))
                }
            }
        }
    }
}

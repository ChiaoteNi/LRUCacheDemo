//
//  LRUCache.swift
//  LRUCacheDemo
//
//  Created by Aaron_Ni on 2020/2/13.
//  Copyright © 2020 Aaron_Ni. All rights reserved.
//

import Foundation

final class LRUCache<Key: Hashable, Value> {
    
    typealias Node = LinkNode<Key>
    
    private struct CacheItem {
        let content: Value
        let node: Node
    }
    
    private var caches: [Key: CacheItem] = [:]
    private var list: LinkList<Key> = .init()
    
    private var maxCacheSize: Int
    
    var desc: String { return getDesc() }
    
    init(maxCacheSize: Int) {
        self.maxCacheSize = maxCacheSize
    }
    
    func setCache(key: Key, value: Value) {
        let cache: CacheItem = .init(content: value,
                                     node: .init(value: key))
        if caches[key] != nil {
            removeCache(of: key)
        }
        insert(cache, with: key)
        
        while list.count > maxCacheSize {
            guard let node = list.last else { break }
            removeCache(of: node.value)
        }
    }
    
    func getCache(key: Key) -> Value? {
        guard let cache = caches[key] else { return nil }
        removeCache(of: key)
        insert(cache, with: key)
        return cache.content
    }
    
}

extension LRUCache {
    
    func removeCache(of key: Key) {
        guard let cache = caches[key] else { return }
        list.remove(cache.node)
        caches.removeValue(forKey: key)
    }
    
    private func insert(_ cache: CacheItem, with key: Key) {
        list.insertNodeAtFirst(cache.node)
        caches[key] = cache
    }
    
    private func getDesc() -> String {
        guard var node = list.first else { return "" }
        
        var index = 0
        var desc = "\(index). \(node.value)\n"
        while let next = node.nextNode {
            index += 1
            node = next
            desc += "\(index). \(node.value)\n"
        }
        return desc
    }
}

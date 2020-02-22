//
//  LinkedList.swift
//  LRUCacheDemo
//
//  Created by Aaron_Ni on 2020/1/31.
//  Copyright © 2020 Aaron_Ni. All rights reserved.
//

import Foundation

final class LinkNode<T> {
    
    var value: T
    var nextNode: LinkNode?
    weak var preNode: LinkNode?
    
    var desc: String {
        return "pre=\(preNode?.value), next=\(nextNode?.value)"
    }
    
    init(value: T) {
        self.value = value
    }
}

final class LinkList<T: Hashable> {
    
    typealias Node = LinkNode<T>
    
    var first: Node?
    weak var last: Node?
    
    var count: Int {
        guard var element = first else { return 0 }
        var count: Int = 1
        while let nextItem = element.nextNode {
            element = nextItem
            count += 1
        }
        return count
    }
    
    var desc: String {
        guard var element = first else { return "" }
        var text = element.desc
        while let next = element.nextNode {
            text += "\n\(next.desc)"
            element = next
        }
        return text
    }
    
    func insertNodeAtFirst(_ node: Node) {
        insert(node, before: first)
    }
    
    func insert(_ node: Node, before targetNode: Node?) {
        node.nextNode = targetNode
        node.preNode = targetNode?.preNode
        targetNode?.preNode = node
        
        if node.preNode == nil {
            first = node
        }
        
        if targetNode?.nextNode == nil {
            last = targetNode
        }
    }
    
    @discardableResult
    func remove(_ node: Node) -> Node {
        let next = node.nextNode
        let pre = node.preNode

        if let pre = pre {
            pre.nextNode = next
        } else {
            first = next
        }
        next?.preNode = pre
        
        if node.preNode == nil {
            first = next
        }
        
        if node.nextNode == nil {
            last = pre
        }

        node.nextNode = nil
        node.preNode = nil
        
        return node
    }
}

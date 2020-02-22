//
//  ViewController.swift
//  LRUCacheDemo
//
//  Created by Aaron_Ni on 2020/1/28.
//  Copyright © 2020 Aaron_Ni. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet private weak var inputField: UITextField!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var resultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
    }
}

// IBActions
extension ViewController {
    
    @IBAction private func sendApi() {
        guard let text = inputField.text
            , let time = Int(text) else { return }
        
        inputField.text = nil
        let startTime: Date = .init()
        
        // 這是一個很小的Demo，請先讓我們忽略在VC呼叫api這件事XD
        DemoAPI.cacheDemo(waitTime: time) { result in
            switch result {
            case .success(let message):
                print("🎃🎃🎃\(message)🎃🎃🎃")
                let distance = Date().timeIntervalSince(startTime)
                self.showResult(timeDistance: Int(distance))
            case .failure(let error):
                print("💀💀💀\(error)💀💀💀")
            }
        }
    }
}

// Private funcs
extension ViewController {
    
    private func initSetup() {
        inputField.keyboardType = .numberPad
        inputField.placeholder = "請輸入API回傳間隔時間"
        submitButton.setTitle("發送", for: .normal)
        resultLabel.text =
            "這邊顯示Api response時間，與當下的Cache項目及內容。\n"
            + "\n當設定秒數已存在Cache中時，CacheItem的順序會被調整到第一位，"
            + "\n並直接回傳cache內容而不重送API，故0秒便會取得API response"
    }
    
    private func showResult(timeDistance: Int) {
        print("-------------")
        print(APICacheManager.shared.caches.desc)
        print("=============")
        resultLabel.text = "共經過 \(timeDistance) 秒\n" + (APICacheManager.shared.caches.desc)
    }
}


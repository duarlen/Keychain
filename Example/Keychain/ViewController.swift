//
//  ViewController.swift
//  Keychain
//
//  Created by dulinshun on 12/23/2021.
//  Copyright (c) 2021 dulinshun. All rights reserved.
//

import UIKit
import Keychain

class ViewController: UIViewController {

    let tf1 = UITextField()
    let tf2 = UITextField()
    let btn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tf1.borderStyle = .roundedRect
        tf2.borderStyle = .roundedRect
        btn.backgroundColor = .blue
        
        tf1.placeholder = "账户"
        tf2.placeholder = "密码"
        btn.setTitle("保存", for: .normal)
        btn.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        
        view.addSubview(tf1)
        view.addSubview(tf2)
        view.addSubview(btn)
        
        insertDefaultData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = view.frame.size.width
        tf1.frame = CGRect(x: 60, y: 100, width: width - 120, height: 30)
        tf2.frame = CGRect(x: 60, y: 150, width: width - 120, height: 30)
        btn.frame = CGRect(x: 60, y: 200, width: width - 120, height: 30)
    }
    
    func insertDefaultData() {
        if let data = KeychainManager.query(identifier: "ceshi") as? String {
            let strs = data.components(separatedBy: ",")
            if strs.count == 2 {
                tf1.text = strs[0]
                tf2.text = strs[1]
            }
        }
    }
    
    @objc func saveData() {
        guard let act = tf1.text else { return }
        guard let pwd = tf2.text else { return }
        let data = [act, pwd].joined(separator: ",")
        let res = KeychainManager.insert(data: data, identifier: "ceshi")
        print("存储结果", res)
    }
}


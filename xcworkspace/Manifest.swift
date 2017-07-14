//
//  Manifest.swift
//  MakeSketchplugin
//
//  Created by 孙继刚 on 2017/7/13.
//  Copyright © 2017年 madordie. All rights reserved.
//

import Cocoa

class Manifest {

	let name = "Fill Strings"
	let description = "自动填充工具"
	let identifier = "com.madordie.sketchplugin.Fill-Strings"
    let version = "1.0.0"
	let author = "Keith"
	let authorEmail = "e.madordie@gmail.com"
	var commands = [String?]()

    func json() -> String {
        let tools = commands.flatMap { $0 }.joined(separator: ",")
        return "{\"name\":\"\(name)\",\"identifier\":\"\(identifier)\",\"version\":\"\(version)\",\"description\":\"\(description)\",\"authorEmail\":\"\(authorEmail)\",\"author\":\"\(author)\",\"commands\":[\(tools)]}"
    }
}

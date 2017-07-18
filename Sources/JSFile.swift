//
//  FileForJS.swift
//  MakeSketchplugin
//
//  Created by 孙继刚 on 2017/7/13.
//  Copyright © 2017年 madordie. All rights reserved.
//

import Cocoa

class JSFile {
    let url: URL
    let name: String
    var toContents: String?
    var savePath: String?
    var resourcesPath: String?
    var fileName: String { return name + ".js" }

    init?(_ url: URL) {
        self.url = url
        name = url.lastPathComponent
    }

    func save() {
        guard let path = savePath else {
            Log.p("我还无法识别你的sketch, 联系我给你兼容吧。。")
            return
        }
        if FileManager.default.createFile(atPath: path, contents: toContents?.data(using: .utf8), attributes: nil) {
            Log.p("\(fileName)已生成")
        } else {
            Log.p("\(fileName)无法写入..")
        }
    }

    func command() -> String? {
        return "{\"script\":\"\(fileName)\",\"handler\":\"onRun\",\"shortcut\":\"\",\"name\":\"\(name)\",\"identifier\":\"\(name)\"}"
    }
}

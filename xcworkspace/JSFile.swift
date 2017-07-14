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
    let fromContents: String
    var toContents: String?
    var savePath: String?
    var fileName: String { return name + ".js" }

    init?(_ url: URL) {
        do {
            fromContents = try String(contentsOf: url)
            self.url = url
            name = url.lastPathComponent
            Log.p("input " + name + " OK.")
        } catch {
            Log.p("input " + url.lastPathComponent + " empty!")
            return nil
        }
    }

    func save() {
        guard let path = savePath else { return }
        // 文件写入
        Log.p("writing " + fileName + "...")
        if FileManager.default.createFile(atPath: path, contents: toContents?.data(using: .utf8), attributes: nil) {
            Log.p("writed " + fileName + ".")
        }
    }

    func command() -> String? {
        return "{\"script\":\"\(fileName)\",\"handler\":\"onRun\",\"shortcut\":\"\",\"name\":\"\(name)\",\"identifier\":\"\(name)\"}"
    }
}

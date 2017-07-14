//
//  SketchPlugin.swift
//  MakeSketchplugin
//
//  Created by 孙继刚 on 2017/7/13.
//  Copyright © 2017年 madordie. All rights reserved.
//

import Cocoa

open class SketchPlugin {
    /// 主目录信息
    let manifest = Manifest()
    var files = [JSFile]()
    var path: URL?

    func save() -> Bool {

        guard files.count > 0 else {
            Log.p("什么资源都不导入，这样制作出来的插件什么也干不了的哦～")
            return false
        }

        guard let path = path?.appendingPathComponent("\(manifest.name).sketchplugin/Contents/Sketch") else {
            Log.p("无法识别生成目录:\(String(describing: self.path))")
            return false
        }

        manifest.commands = files.flatMap { $0.command() }
        do {
            if FileManager.default.isExecutableFile(atPath: path.path) {
                try FileManager.default.removeItem(atPath: path.path)
            }
            try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
            guard FileManager.default.createFile(atPath: path.appendingPathComponent("/manifest.json").path, contents: manifest.json().data(using: .utf8), attributes: nil) else {
                Log.p("最关键的manifest.json无法写入:\(path)")
                return false
            }

            for file in files {
                file.savePath = path.appendingPathComponent(file.fileName).path
                file.save()
            }
        } catch {
            Log.p("目录操作失败：\(path)\(error)")
            return false
        }
        Log.p("制作完毕！生成路径:\(path)")
        return true
    }
}

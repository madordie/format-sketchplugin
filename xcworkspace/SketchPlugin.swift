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

    func save() {
        guard let path = path?.appendingPathComponent("\(manifest.name).sketchplugin/Contents/Sketch") else { return }

        manifest.commands = files.flatMap { $0.command() }
        do {
            try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
            guard FileManager.default.createFile(atPath: path.appendingPathComponent("/manifest.json").path, contents: manifest.json().data(using: .utf8), attributes: nil) else { return }

            for file in files {
                file.savePath = path.appendingPathComponent(file.fileName).path
                file.save()
            }
            Log.p("save OK!")
        } catch {
            Log.p("save error:\(error)")
            return
        }
    }
}

//
//  FillImages.swift
//  MakeSketchplugin
//
//  Created by 孙继刚 on 2017/7/14.
//  Copyright © 2017年 madordie. All rights reserved.
//

import Cocoa

class FillImages: JSFile {

    let images: [Image]

    override init?(_ url: URL) {
        var isDir: ObjCBool = false
        let path = url.path
        guard FileManager.default.fileExists(atPath: path, isDirectory: &isDir) else {
            Log.p("\(path)目录不存在..")
            return nil
        }
        guard isDir.boolValue else {
            Log.p("\(path)并不是一个目录, 可能是个文件..")
            return nil
        }
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: path)
            images = files.flatMap { Image(URL(fileURLWithPath: path.appending("/" + $0))) }
            guard images.count > 0 else {
                Log.p("\(path)目录下没找到图片文件..")
                return nil
            }
        } catch {
            Log.p("糟糕，读取\(path)时出错了...\(error)\n")
            return nil
        }
        super.init(url)
        Log.p("读取到图片库\(url.lastPathComponent)")
    }

    override func save() {
        guard let savePath = savePath else { return }

        let manager = FileManager.default
        let urls = images.map { $0.url }
        let imagesURL = URL(fileURLWithPath: savePath).deletingLastPathComponent().appendingPathComponent(name)

        var toUrls = [String]()
        do {
            for url in urls {
                try FileManager.default.createDirectory(at: imagesURL, withIntermediateDirectories: true, attributes: nil)
                let toUrl = imagesURL.appendingPathComponent(url.lastPathComponent)
                try manager.copyItem(at: url, to: toUrl)
                toUrls.append(toUrl.path)
            }
        } catch {
            Log.p("复制资源图片时出错了...\n\(urls) -> \(imagesURL)\n\(error)\n")
            return
        }
        guard toUrls.count > 0 else {
            Log.p("该文件夹下没有我能挪过去资源:\(urls)")
            return
        }

        let source = "[\"" + toUrls.joined(separator: "\",\"") + "\"]"
        toContents = "function onRun(context) { var list=\(source);var selection=context.selection;for(var i=0;i<[selection count];i++){var image=[[NSImage alloc]initByReferencingFile:list[Math.floor(Math.random()*list.length)]];var layer=selection[i];if([layer class]==MSShapeGroup){var fill=layer.style().fills().firstObject();fill.setFillType(4);fill.setImage(MSImageData.alloc().initWithImage_convertColorSpace(image,false));fill.setPatternFillType(1)}} };"

        super.save()
    }

}

class Image {

    static let suffixs = [".png", ".PNG", ".jpg", ".JPG", ".jpeg", ".JPEG", ".gif", ".GIF"]

    let url: URL
    init?(_ url: URL) {
        var isDir: ObjCBool = false
        guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir) else { return nil }
        guard isDir.boolValue == false else { return nil }

        for sufix in Image.suffixs {
            if url.lastPathComponent.hasSuffix(sufix) {
                self.url = url
                return
            }
        }
        return nil
    }

}

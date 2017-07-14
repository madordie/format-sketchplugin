//
//  FillStrings.swift
//  MakeSketchplugin
//
//  Created by 孙继刚 on 2017/7/13.
//  Copyright © 2017年 madordie. All rights reserved.
//

import Cocoa

class FillStrings: JSFile {

    override init?(_ url: URL) {
        super.init(url)
    }

    override func save() {
        let list = fromContents.components(separatedBy: "\n").flatMap { (line) -> String? in
            guard line.characters.count > 0 else { return nil }
            guard line.components(separatedBy: " ").count > 0 else { return nil }
            return line
        }
        guard list.count > 0 else { return }
        let source = "[\"" + list.joined(separator: "\",\"") + "\"]"
        toContents = "function onRun(context) { var list = \(source);var sketch = context.api();sketch.selectedDocument.selectedLayers.iterateWithFilter(\"isText\", function(layer) {layer.text = list[Math.floor(Math.random()*list.length)];}) };"
        super.save()
    }
}

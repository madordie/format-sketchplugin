//
//  DDView.swift
//  MakeSketchplugin
//
//  Created by 孙继刚 on 2017/7/17.
//  Copyright © 2017年 madordie. All rights reserved.
//

import Cocoa
import RxSwift

class DDView: NSView {

    let draggingUrls = Variable([URL]())

    fileprivate var isDragIn = false {
        didSet {
            guard isDragIn != oldValue else { return }
            setNeedsDisplay(bounds)
        }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    func setup() {
        register(forDraggedTypes: [NSFilenamesPboardType])
    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        if isDragIn {
            NSColor(red: 220.0/255, green: 220.0/255, blue: 220.0/255, alpha: 1).set()
            NSBezierPath(roundedRect: dirtyRect, xRadius: 8, yRadius: 8).fill()
        }
    }
}

extension DDView {
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        isDragIn = true
        return .copy
    }
    override func draggingExited(_ sender: NSDraggingInfo?) {
        isDragIn = false
    }
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        isDragIn = false
        return true
    }
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard sender.draggingPasteboard() != self else { return true }
        let urls = sender.draggingPasteboard().propertyList(forType: NSFilenamesPboardType)
        if let urls = urls as? [String] {
            draggingUrls.value = urls.map { URL(fileURLWithPath: $0) }
        }
        return true
    }
}

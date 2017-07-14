//
//  ViewController.swift
//  MakeSketchplugin
//
//  Created by 孙继刚 on 2017/7/13.
//  Copyright © 2017年 madordie. All rights reserved.
//

import Cocoa
import RxSwift

class ViewController: NSViewController {
    let bag = DisposeBag()
    @IBOutlet var log: NSTextView!

    let manager = SketchPlugin()

    override func viewDidLoad() {
        super.viewDidLoad()
        manager.path = {
            var path = FileManager.default.homeDirectoryForCurrentUser
            path.appendPathComponent("Library/Application Support/com.bohemiancoding.sketch3/Plugins")
            return path
        }()
        log.isEditable = false
        Log.default.inout.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (log) in
                guard let _self = self else { return }
                _self.log.string = (_self.log.string ?? "") + "\n" + log
                _self.log.scrollRangeToVisible(NSRange(location: _self.log.string?.characters.count ?? 0, length: 1))
        }).addDisposableTo(bag)
    }

    @IBAction func installAction(_ sender: NSButton) {
        if manager.save()  {
            sender.title = "制作完成！再重新来一次？"
        }
    }

    @IBAction func openAction(_ sender: NSButton) {
        let oPanel: NSOpenPanel = NSOpenPanel()
        oPanel.canChooseDirectories = false
        oPanel.canChooseFiles = true
        oPanel.allowsMultipleSelection = true
        oPanel.prompt = "我选好了"

        oPanel.beginSheetModal(for: self.view.window!, completionHandler: { (button : Int) -> Void in
            guard button == NSFileHandlingPanelOKButton else { return }
            if var pathComponents = oPanel.urls.first?.pathComponents {
                pathComponents.removeLast()
                if let path = pathComponents.last {
                    sender.title = path
                }
            }
            self.manager.files += oPanel.urls.flatMap { FillStrings($0) }
            let count = self.manager.files.flatMap({ $0 is FillStrings ? $0 : nil }).count
            sender.title = count == 0 ? "无法识别...再选一次?" : "已选择\(count)个文本文件，还要继续?"
        })
    }
    @IBAction func imageOpenAction(_ sender: NSButton) {
        let oPanel: NSOpenPanel = NSOpenPanel()
        oPanel.canChooseDirectories = true
        oPanel.canChooseFiles = false
        oPanel.allowsMultipleSelection = true
        oPanel.prompt = "我选好了"

        oPanel.beginSheetModal(for: self.view.window!, completionHandler: { (button : Int) -> Void in
            guard button == NSFileHandlingPanelOKButton else { return }
            if var pathComponents = oPanel.urls.first?.pathComponents {
                pathComponents.removeLast()
                if let path = pathComponents.last {
                    sender.title = path
                }
            }
            self.manager.files += oPanel.urls.flatMap { FillImages($0) }
            let count = self.manager.files.flatMap({ $0 is FillImages ? $0 : nil }).count
            sender.title = count == 0 ? "没有识别到...再来一次?" : "已选择\(count)个图片库，还要继续？"
        })
    }
}

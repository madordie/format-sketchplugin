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
        manager.save()
    }

    @IBAction func openAction(_ sender: NSButton) {
        let oPanel: NSOpenPanel = NSOpenPanel()
        oPanel.canChooseDirectories = false
        oPanel.canChooseFiles = true
        oPanel.allowsMultipleSelection = true
        oPanel.prompt = "选择数据源文件"
        
        oPanel.beginSheetModal(for: self.view.window!, completionHandler: { (button : Int) -> Void in
            guard button == NSFileHandlingPanelOKButton else { return }
            self.manager.files += oPanel.urls.flatMap { FillStrings($0) }
        })
    }
}

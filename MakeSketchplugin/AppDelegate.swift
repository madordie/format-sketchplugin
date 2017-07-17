//
//  AppDelegate.swift
//  MakeSketchplugin
//
//  Created by 孙继刚 on 2017/7/13.
//  Copyright © 2017年 madordie. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func checkForUpdatesAction(_ sender: NSMenuItem) {
        let versionChecker = VersionChecker()
        DispatchQueue.global().async {
            let newVersion = versionChecker.checkNewVersion()
            DispatchQueue.main.async {
                if (newVersion["newVersion"] as! Bool){
                    let alertResult = versionChecker.showAlertView(Title: newVersion["Title"] as! String, SubTitle: newVersion["SubTitle"] as! String, ConfirmBtn: newVersion["ConfirmBtn"] as! String, CancelBtn: newVersion["CancelBtn"] as! String)
                    print(alertResult)
                    if (newVersion["newVersion"] as! Bool && alertResult == 1000){
                        NSWorkspace.shared().open(URL(string: "https://github.com/madordie/format-sketchplugin/releases")!)
                    }
                }
            }
        }
    }

    @IBAction func documentationAction(_ sender: NSMenuItem) {
        NSWorkspace.shared().open(URL(string: "https://github.com/madordie/format-sketchplugin")!)
    }
}



let _VERSION_XML_URL = "https://raw.githubusercontent.com/madordie/format-sketchplugin/master/MakeSketchplugin/Info.plist"
let _VERSION_XML_LOCAL:String = Bundle.main.bundlePath + "/Contents/Info.plist"

// source : https://github.com/shadowsocksr/ShadowsocksX-NG/blob/develop/ShadowsocksX-NG/VersionChecker.swift
class VersionChecker: NSObject {
    var haveNewVersion: Bool = false
    enum versionError: Error {
        case CanNotGetOnlineData
    }
    func saveFile(fromURL: String, toPath: String, withName: String) -> Bool {
        let manager = FileManager.default
        let url = URL(string:fromURL)!
        do {
            let st = try String(contentsOf: url, encoding: String.Encoding.utf8)
            print(st)
            let data = st.data(using: String.Encoding.utf8)
            manager.createFile( atPath: toPath + withName , contents: data, attributes: nil)
            return true

        } catch {
            print(error)
            return false
        }
    }
    func showAlertView(Title: String, SubTitle: String, ConfirmBtn: String, CancelBtn: String) -> Int {
        let alertView = NSAlert()
        alertView.messageText = Title
        alertView.informativeText = SubTitle
        alertView.addButton(withTitle: ConfirmBtn)
        if CancelBtn != "" {
            alertView.addButton(withTitle: CancelBtn)
        }
        let action = alertView.runModal()
        return action
    }
    func parserVersionString(strIn: String) -> Array<Int>{
        var strTmp = strIn
        if !strTmp.hasSuffix(".") {
            strTmp += "."
        }
        var ret = [Int]()

        repeat {
            ret.append(Int(strTmp.substring(to: strTmp.range(of: ".")!.lowerBound))!)
            print(strTmp.substring(to: strTmp.range(of: ".")!.lowerBound))
            strTmp = strTmp.substring(from: strTmp.range(of: ".")!.upperBound)
        } while(strTmp.range(of: ".") != nil);

        return ret
    }
    func checkNewVersion() -> [String:Any] {
        // return
        // newVersion: Bool,
        // error: String,
        // alertTitle: String,
        // alertSubtitle: String,
        // alertConfirmBtn: String,
        // alertCancelBtn: String
        let showAlert: Bool = true
        func getOnlineData() throws -> NSDictionary{
            guard NSDictionary(contentsOf: URL(string:_VERSION_XML_URL)!) != nil else {
                throw versionError.CanNotGetOnlineData
            }
            return NSDictionary(contentsOf: URL(string:_VERSION_XML_URL)!)!
        }

        var localData: NSDictionary = NSDictionary()
        var onlineData: NSDictionary = NSDictionary()

        localData = NSDictionary(contentsOfFile: _VERSION_XML_LOCAL)!
        do{
            try onlineData = getOnlineData()
        }catch{
            return ["newVersion" : false,
                    "error": "network error",
                    "Title": "网络错误",
                    "SubTitle": "由于网络错误无法检查更新",
                    "ConfirmBtn": "确认",
                    "CancelBtn": ""
            ]
        }

        let versionString:String = onlineData["CFBundleShortVersionString"] as! String
        let buildString:String = onlineData["CFBundleVersion"] as! String
        let currentVersionString:String = localData["CFBundleShortVersionString"] as! String
        let currentBuildString:String = localData["CFBundleVersion"] as! String
        var subtitle:String
        if (versionString == currentVersionString){

            if buildString == currentBuildString {

                subtitle = "当前版本 " + currentVersionString + " build " + currentBuildString
                return ["newVersion" : false,
                        "error": "",
                        "Title": "已是最新版本！",
                        "SubTitle": subtitle,
                        "ConfirmBtn": "确认",
                        "CancelBtn": ""
                ]
            }
            else {
                haveNewVersion = true

                subtitle = "新版本为 " + versionString + " build " + buildString + "\n" + "当前版本 " + currentVersionString + " build " + currentBuildString
                return ["newVersion" : true,
                        "error": "",
                        "Title": "软件有更新！",
                        "SubTitle": subtitle,
                        "ConfirmBtn": "前往下载",
                        "CancelBtn": "取消"
                ]
            }
        }
        else{
            // 处理如果本地版本竟然比远程还新

            var versionArr = parserVersionString(strIn: onlineData["CFBundleShortVersionString"] as! String)
            var currentVersionArr = parserVersionString(strIn: localData["CFBundleShortVersionString"] as! String)

            // 做补0处理
            while (max(versionArr.count, currentVersionArr.count) != min(versionArr.count, currentVersionArr.count)) {
                if (versionArr.count < currentVersionArr.count) {
                    versionArr.append(0)
                }
                else {
                    currentVersionArr.append(0)
                }
            }

            for i in 0...(currentVersionArr.count - 1) {
                if versionArr[i] > currentVersionArr[i] {
                    haveNewVersion = true
                    subtitle = "新版本为 " + versionString + " build " + buildString + "\n" + "当前版本 " + currentVersionString + " build " + currentBuildString
                    return ["newVersion" : true,
                            "error": "",
                            "Title": "软件有更新！",
                            "SubTitle": subtitle,
                            "ConfirmBtn": "前往下载",
                            "CancelBtn": "取消"
                    ]
                }
            }
            subtitle = "当前版本 " + currentVersionString + " build " + currentBuildString + "\n" + "远端版本 " + versionString + " build " + buildString
            return ["newVersion" : false,
                    "error": "",
                    "Title": "已是最新版本！",
                    "SubTitle": subtitle,
                    "ConfirmBtn": "确认",
                    "CancelBtn": ""
            ]
        }
    }
}

//
//  Manifest.swift
//  MakeSketchplugin
//
//  Created by 孙继刚 on 2017/7/13.
//  Copyright © 2017年 madordie. All rights reserved.
//

import Cocoa
import ObjectMapper

class Manifest: Mappable{

	var author: String?
	var authorEmail: String?
	var commands: [Command]?
	var description: String?
	var identifier: String?
	var name: String?
	var version: String?

	required init?(map: Map){}

	func mapping(map: Map)
	{
		author <- map["author"]
		authorEmail <- map["authorEmail"]
		commands <- map["commands"]
		description <- map["description"]
		identifier <- map["identifier"]
		name <- map["name"]
		version <- map["version"]
	}

}

class Command: Mappable{

	var handler: String?
	var identifier: String?
	var name: String?
	var script: String?
	var shortcut: String?

	required init?(map: Map){}

	func mapping(map: Map)
	{
		handler <- map["handler"]
		identifier <- map["identifier"]
		name <- map["name"]
		script <- map["script"]
		shortcut <- map["shortcut"]
	}

}

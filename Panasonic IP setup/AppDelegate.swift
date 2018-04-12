//
//  AppDelegate.swift
//  Panasonic IP setup
//
//  Created by Damiaan on 12/04/18.
//  Copyright © 2018 Devian. All rights reserved.
//

import Cocoa
import PanasonicEasyIPsetupCore

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	override init() {
		super.init()
	}

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
	
	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		return true
	}
}

class UnifiedWindow: NSWindow {
	override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
		super.init(
			contentRect: contentRect,
			styleMask: style.union(.unifiedTitleAndToolbar),
			backing: backingStoreType,
			defer: flag
		)
		
		titleVisibility = .hidden
	}
}

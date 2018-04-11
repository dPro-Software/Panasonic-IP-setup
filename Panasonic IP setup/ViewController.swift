//
//  ViewController.swift
//  Panasonic IP setup
//
//  Created by Damiaan on 12/04/18.
//  Copyright © 2018 Devian. All rights reserved.
//

import Cocoa
import PanasonicEasyIPsetupBlueSocket
import PanasonicEasyIPsetupCore

class ViewController: NSViewController {
	@IBOutlet weak var cameraCountLabel: NSTextField!
	
	var manager: Manager?
	
	override func viewDidLoad() {
		super.viewDidLoad()

		do {
			let manager = try Manager() { error in
				self.presentError(error)
			}
			self.manager = manager
			manager.discoveryHandler = { _ in
				DispatchQueue.main.sync {
					self.cameraCountLabel.stringValue = "\(manager.configurations.count)"
				}
			}
		} catch {
			presentError(error)
		}
	}
}


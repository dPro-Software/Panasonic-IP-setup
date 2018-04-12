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
	var manager: Manager?
	@IBOutlet var cameraArrayController: NSArrayController!
	
	@IBAction func refresh(_ sender: Any) {
		print("refresh")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		do {
			let manager = try Manager() { error in
				self.presentError(error)
			}
			self.manager = manager
			manager.discoveryHandler = { configuration in
				DispatchQueue.main.sync {
					let wrapper = ConfigurationWrapper(with: configuration)
					self.cameraArrayController.insert(wrapper, atArrangedObjectIndex: 0)
				}
			}
		} catch {
			presentError(error)
		}
	}
}

func format(_ address: IPv4Address) -> String {
	return address.map(String.init).joined(separator: ".")
}

class ConfigurationWrapper: NSObject {
	let configuration: CameraConfiguration
	init(with original: CameraConfiguration) {
		configuration = original
	}
	
	@objc dynamic var model: String { return configuration.model }
	@objc dynamic var name: String { return configuration.name }
	@objc dynamic var port: UInt16 { return configuration.port }
	
	@objc dynamic var macAddress: String {
		return configuration
			.macAddress
			.map { String(format: "%02X", $0) }
			.joined(separator: ":")
	}
	
	@objc dynamic var ipAddress: String { return format(configuration.ipV4address)}
	@objc dynamic var gateway: String { return format(configuration.gateway)}
	@objc dynamic var netmask: String { return format(configuration.netmask)}
	@objc dynamic var dns1: String { return format(configuration.primaryDNS)}
	@objc dynamic var dns2: String { return format(configuration.secondaryDNS)}
}

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
		cameraArrayController.remove(contentsOf: cameraArrayController.arrangedObjects as! [Any])
		do {
			try manager?.search()
		} catch {
			DispatchQueue.main.async {
				self.presentError(error)
			}
		}
	}
	
	@IBAction func reconfigure(_ sender: Any) {
		if let wrapper = cameraArrayController.selectedObjects.first as? ConfigurationWrapper {
			do {
				try manager?.set(configuration: wrapper.currentConfiguration)
			} catch {
				DispatchQueue.main.async {
					self.presentError(error)
				}
			}
		} else {
			print("no config selected")
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		do {
			let manager = try Manager() { error in
				DispatchQueue.main.async {
					self.presentError(error)
				}
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

func getNetmask(from address: IPv4Address) -> UInt8 {
	var netmask = UInt8(0)
	for byte in address {
		switch byte {
		case 255: netmask += 8
		case 1..<255: return netmask + UInt8(8 - log2(Double(~byte) + 1))
		default: return netmask
		}
	}
	return netmask
}

class ConfigurationWrapper: NSObject {
	let originalConfiguration: CameraConfiguration
	init(with original: CameraConfiguration) {
		originalConfiguration = original
		
		netmask = getNetmask(from: originalConfiguration.netmask)
		ipAddress = IPAddress(bytes: originalConfiguration.ipV4address)
		gateway = IPAddress(bytes: originalConfiguration.gateway)
		primaryDNS = IPAddress(bytes: originalConfiguration.primaryDNS)
		secondaryDNS = IPAddress(bytes: originalConfiguration.secondaryDNS)
	}
	
	var currentConfiguration: CameraConfiguration {
		return CameraConfiguration(
			macAddress: originalConfiguration.macAddress,
			ipV4address: ipAddress.bytes,
			netmask: netmaskBytes,
			gateway: gateway.bytes,
			primaryDNS: primaryDNS.bytes,
			secondaryDNS: secondaryDNS.bytes,
			port: port,
			model: model,
			name: name
		)
	}
	
	@objc dynamic var hasChanged: Bool {
		return currentConfiguration != originalConfiguration
	}
	
	override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
		if key == "hasChanged" {
			return [
				"port",
				"ipAddress.byte0", "ipAddress.byte1", "ipAddress.byte2", "ipAddress.byte3",
				"gateway.byte0", "gateway.byte1", "gateway.byte2", "gateway.byte3",
				"primaryDNS.byte0", "primaryDNS.byte1", "primaryDNS.byte2", "primaryDNS.byte3",
				"secondaryDNS.byte0", "secondaryDNS.byte1", "secondaryDNS.byte2", "secondaryDNS.byte3",
				"netmask.byte0", "netmask.byte1", "netmask.byte2", "netmask.byte3"
			]
		} else {
			return super.keyPathsForValuesAffectingValue(forKey: key)
		}
	}
	
	@objc dynamic var model: String { return originalConfiguration.model }
	@objc dynamic var name: String { return originalConfiguration.name }
	@objc dynamic var port: UInt16 { return originalConfiguration.port }
	
	@objc dynamic var macAddress: String {
		return originalConfiguration
			.macAddress
			.map { String(format: "%02X", $0) }
			.joined(separator: ":")
	}
	
	@objc dynamic var ipAddress: IPAddress
	@objc dynamic var gateway: IPAddress
	@objc dynamic var primaryDNS: IPAddress
	@objc dynamic var secondaryDNS: IPAddress
	@objc dynamic var netmask: UInt8 {
		willSet { if newValue != netmask {willChangeValue(for: \.netmaskString)} }
		didSet  { if oldValue != netmask { didChangeValue(for: \.netmaskString)} }
	}
	
	@objc dynamic var netmaskString: String {
		return netmaskBytes
			.map(String.init)
			.joined(separator: ".") + " (\(netmask))"
	}
	
	var netmaskBytes: [UInt8] {
		let byte1: UInt8 = ~(0xff >> netmask)
		let byte2: UInt8 = ~(0xff >> (netmask - min(netmask, 8)) )
		let byte3: UInt8 = ~(0xff >> (netmask - min(netmask, 16)) )
		let byte4: UInt8 = ~(0xff >> (netmask - min(netmask, 24)) )
		return [byte1, byte2, byte3, byte4]
	}
}

class IPAddress: NSObject {
	@objc dynamic var byte0, byte1, byte2, byte3: UInt8

	init(bytes: [UInt8]) {
		(byte0, byte1, byte2, byte3) = (bytes[0], bytes[1], bytes[2], bytes[3])
	}
	
	var bytes: [UInt8] {
		return [byte0, byte1, byte2, byte3]
	}
}

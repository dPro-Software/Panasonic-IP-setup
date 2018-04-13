//
//  DetailViewController.swift
//  IP Setup
//
//  Created by Damiaan on 13/04/18.
//  Copyright © 2018 Devian. All rights reserved.
//

import UIKit
import PanasonicEasyIPsetupCore

class DetailViewController: UIViewController {

	@IBOutlet weak var modelLabel: UILabel?
	@IBOutlet weak var nameLabel: UILabel?
	@IBOutlet weak var macAddressLabel: UILabel?
	@IBOutlet weak var ipAddressLabel: UILabel?
	@IBOutlet weak var netmaskLabel: UILabel?
	@IBOutlet weak var portLabel: UILabel?
	@IBOutlet weak var dns1: UILabel?
	@IBOutlet weak var dns2: UILabel?
	
	func format(address: IPv4Address) -> String {
		return address.map(String.init).joined(separator: ".")
	}
	
	func configureView() {
		// Update the user interface for the detail item.
		if let detail = detailItem {
		    modelLabel?.text = detail.model
			nameLabel?.text = detail.name
			macAddressLabel?.text = detail.macAddress.map{String(format: "%02X", $0)}.joined(separator: ":")
			ipAddressLabel?.text = format(address: detail.ipV4address)
			netmaskLabel?.text = format(address: detail.netmask)
			portLabel?.text = "\(detail.port)"
			dns1?.text = format(address: detail.primaryDNS)
			dns2?.text = format(address: detail.secondaryDNS)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		configureView()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	var detailItem: CameraConfiguration? {
		didSet {
		    // Update the view.
		    configureView()
		}
	}


}


//
//  MasterViewController.swift
//  IP Setup
//
//  Created by Damiaan on 13/04/18.
//  Copyright © 2018 Devian. All rights reserved.
//

import UIKit
import PanasonicEasyIPsetupCore

class MasterViewController: UITableViewController {

	var detailViewController: DetailViewController? = nil
	var objects = [CameraConfiguration]()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		refreshControl = UIRefreshControl()
		refreshControl!.addTarget(self, action: #selector(searchCameras(_:)), for: .valueChanged)
		
		if let split = splitViewController {
		    let controllers = split.viewControllers
		    detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
		}
		
		if let manager = manager {
			objects.removeAll(keepingCapacity: true)
			objects.append(contentsOf: manager.configurations)
			manager.discoveryHandler = {
				self.objects.insert($0, at: 0)
				DispatchQueue.main.async {
					self.refreshControl?.endRefreshing()
					self.tableView.reloadData()
				}
			}
		} else {
			print("no manager found")
		}
	}
	
	@objc func searchCameras(_ sender: Any?) {
		do {
			objects.removeAll(keepingCapacity: true)
			try manager?.search()
			print("DiscoveryMessage is sent")
		} catch {
			print(error)
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
		super.viewWillAppear(animated)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: - Segues

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDetail" {
		    if let indexPath = tableView.indexPathForSelectedRow {
		        let object = objects[indexPath.row]
		        let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
		        controller.detailItem = object
		        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
		        controller.navigationItem.leftItemsSupplementBackButton = true
		    }
		}
	}

	// MARK: - Table View

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return objects.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		let object = objects[indexPath.row]
		cell.textLabel!.text = object.model
		cell.detailTextLabel?.text = object
			.macAddress
			.map {String(format: "%02X", $0)}
			.joined(separator: ":")
		return cell
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
		    objects.remove(at: indexPath.row)
		    tableView.deleteRows(at: [indexPath], with: .fade)
		} else if editingStyle == .insert {
		    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
		}
	}


}


//
//  SpeedCamerasTableViewController.swift
//  Flits
//
//  Created by Jakob Lierman on 06/01/2019.
//  Copyright © 2019 Jakob Lierman. All rights reserved.
//

import UIKit
import Firebase
import ObjectMapper
import OrderedSet

class SpeedCamerasTableViewController: UITableViewController {

    // MARK: - Properties
    var speedCameras: OrderedSet<SpeedCamera> = []
    // Firebase
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gets data from database and updates on changes
        db.collection("speedCameras").limit(to: 1000).addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    let speedCamera = try! Mapper<SpeedCamera>().map(JSON: diff.document.data())
                    speedCamera.setId(id: diff.document.documentID)
                    self.speedCameras.append(speedCamera)
                }
                if (diff.type == .removed) {
                    let speedCamera = try! Mapper<SpeedCamera>().map(JSON: diff.document.data())
                    speedCamera.setId(id: diff.document.documentID)
                    self.speedCameras.remove(speedCamera)
                }
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the amount of rows
        return speedCameras.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpeedCameraCell", for: indexPath)

        // Get speedCamera
        let speedCamera = speedCameras.sorted().reversed()[indexPath.row]

        // Configure the cell
        cell.textLabel?.text = speedCamera.location
        // Get timeCreated as readable format
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        cell.detailTextLabel?.text = dateFormatter.string(from: speedCamera.timeCreated)
        // Grey text when expired
        if speedCamera.expireDate != nil {
            if Date() > speedCamera.expireDate! {
                cell.textLabel?.isEnabled = false
                cell.detailTextLabel?.isEnabled = false
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Makes sure row does not stay selected
        self.tableView.deselectRow(at: indexPath, animated: true)
        // Go to detailView
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailViewController = (segue.destination as! UINavigationController).topViewController as! SpeedCameraDetailViewController
            if let index = self.tableView.indexPathForSelectedRow {
                detailViewController.speedCamera = speedCameras.sorted().reversed()[index.row]
            }
        }
    }

}

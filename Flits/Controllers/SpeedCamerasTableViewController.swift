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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        // Gets data from database and updates on changes
        /*db.collection("speedCameras").addSnapshotListener { querySnapshot, error in
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
            }
        }*/

        // Dummy data
        let cam1 = SpeedCamera.init(location: "001", kind: "Vaste flitspaal", descriptionText: "desc", imagePath: "")
        cam1.setId(id: "1")
        speedCameras.append(cam1)
        let cam2 = SpeedCamera.init(location: "002", kind: "Flitsauto", descriptionText: "", imagePath: "")
        cam2.setId(id: "2")
        speedCameras.append(cam2)
        let cam3 = SpeedCamera.init(location: "003", kind: "Vaste flitspaal", descriptionText: "", imagePath: "images/speedCameras/v7RxOTngeCzv6MZeIN9c.jpg")
        cam3.setId(id: "3")
        speedCameras.append(cam3)
    }

    // Makes sure row does not stay selected
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
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
        let speedCamera = speedCameras[indexPath.row]

        // Configure the cell
        cell.textLabel?.text = speedCamera.location
        // Get timeCreated as readable format
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        cell.detailTextLabel?.text = dateFormatter.string(from: speedCamera.timeCreated)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailViewController = (segue.destination as! UINavigationController).topViewController as! SpeedCameraDetailViewController
            if let index = self.tableView.indexPathForSelectedRow {
                detailViewController.speedCamera = speedCameras[index.row]
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}

//
//  AvgSpeedCheckTableViewController.swift
//  Flits
//
//  Created by Jakob Lierman on 07/01/2019.
//  Copyright © 2019 Jakob Lierman. All rights reserved.
//

import UIKit
import Firebase
import ObjectMapper
import OrderedSet

class AvgSpeedCheckTableViewController: UITableViewController {

    // MARK: - Properties
    var avgSpeedChecks: OrderedSet<AvgSpeedCheck> = []
    // Firebase
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Gets data from database and updates on changes
        db.collection("avgSpeedChecks").limit(to: 1000).addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    let avgSpeedCheck = try! Mapper<AvgSpeedCheck>().map(JSON: diff.document.data())
                    avgSpeedCheck.setId(id: diff.document.documentID)
                    self.avgSpeedChecks.append(avgSpeedCheck)
                }
                if (diff.type == .removed) {
                    let avgSpeedCheck = try! Mapper<AvgSpeedCheck>().map(JSON: diff.document.data())
                    avgSpeedCheck.setId(id: diff.document.documentID)
                    self.avgSpeedChecks.remove(avgSpeedCheck)
                }
                self.tableView.reloadData()
            }
        }
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
        return avgSpeedChecks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AvgSpeedCheckCell", for: indexPath)

        // Get avgSpeedCheck
        let avgSpeedCheck = avgSpeedChecks[indexPath.row]

        // Configure the cell
        cell.textLabel?.text = avgSpeedCheck.beginLocation
        // Get timeCreated as readable format
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        cell.detailTextLabel?.text = dateFormatter.string(from: avgSpeedCheck.timeCreated)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailViewController = (segue.destination as! UINavigationController).topViewController as! AvgSpeedCheckDetailViewController
            if let index = self.tableView.indexPathForSelectedRow {
                detailViewController.avgSpeedCheck = avgSpeedChecks[index.row]
            }
        }
    }

}

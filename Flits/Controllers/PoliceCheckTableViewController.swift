//
//  PoliceCheckTableViewController.swift
//  Flits
//
//  Created by Jakob Lierman on 07/01/2019.
//  Copyright © 2019 Jakob Lierman. All rights reserved.
//

import UIKit
import Firebase
import ObjectMapper
import OrderedSet

class PoliceCheckTableViewController: UITableViewController {

    // MARK: - Properties
    var policeChecks: OrderedSet<PoliceCheck> = []
    // Firebase
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Gets data from database and updates on changes
        db.collection("policeChecks").limit(to: 1000).addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    let policeCheck = try! Mapper<PoliceCheck>().map(JSON: diff.document.data())
                    policeCheck.setId(id: diff.document.documentID)
                    self.policeChecks.append(policeCheck)
                }
                if (diff.type == .removed) {
                    let policeCheck = try! Mapper<PoliceCheck>().map(JSON: diff.document.data())
                    policeCheck.setId(id: diff.document.documentID)
                    self.policeChecks.remove(policeCheck)
                }
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the amount of rows
        return policeChecks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PoliceCheckCell", for: indexPath)

        // Get policeCheck
        let policeCheck = policeChecks[indexPath.row]

        // Configure the cell
        cell.textLabel?.text = policeCheck.location
        // Get timeCreated as readable format
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        cell.detailTextLabel?.text = dateFormatter.string(from: policeCheck.timeCreated)

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
            let detailViewController = (segue.destination as! UINavigationController).topViewController as! PoliceCheckDetailViewController
            if let index = self.tableView.indexPathForSelectedRow {
                detailViewController.policeCheck = policeChecks[index.row]
            }
        }
    }

}

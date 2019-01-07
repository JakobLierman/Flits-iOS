//
//  SettingsTableViewController.swift
//  Flits
//
//  Created by Jakob Lierman on 23/12/2018.
//  Copyright © 2018 Jakob Lierman. All rights reserved.
//

import UIKit
import Firebase

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: Actions
    @IBAction func changePasswordAction(_ sender: Any) {
        // Placeholder alert
        let alertController = UIAlertController(title: "Binnenkort", message: "Deze functionaliteit is momenteel nog niet bruikbaar.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func signOutAction(_ sender: Any) {
        // Sign out
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }

        // Go back to initial view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

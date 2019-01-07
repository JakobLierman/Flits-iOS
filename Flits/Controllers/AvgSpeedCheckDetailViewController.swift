//
//  AvgSpeedCheckDetailViewController.swift
//  Flits
//
//  Created by Jakob Lierman on 07/01/2019.
//  Copyright © 2019 Jakob Lierman. All rights reserved.
//

import UIKit
import Firebase

class AvgSpeedCheckDetailViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var beginLocationText: UILabel!
    @IBOutlet weak var endLocationText: UILabel!
    // Firebase
    let db = Firestore.firestore()
    
    var avgSpeedCheck: AvgSpeedCheck? {
        didSet {
            refreshUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Loads data in view
    private func refreshUI() {
        loadViewIfNeeded()
        beginLocationText.text = avgSpeedCheck?.beginLocation
        endLocationText.text = avgSpeedCheck?.endLocation
        // Enable delete functionality if user is creator
        if Auth.auth().currentUser?.uid == avgSpeedCheck?.userID {
            deleteButton.isEnabled = true
        }
    }
    
    // MARK: - Actions
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        if Auth.auth().currentUser?.uid == avgSpeedCheck?.userID {
            // Show confirmation alert
            let alertController = UIAlertController(title: "Trajectcontrole verwijderen", message: "Bent u zeker?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Annuleren", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Verwijderen", style: .destructive, handler: { (UIAlertAction) in
                // Delete item from database
                self.db.collection("avgSpeedChecks").document(self.avgSpeedCheck!.id).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }

}

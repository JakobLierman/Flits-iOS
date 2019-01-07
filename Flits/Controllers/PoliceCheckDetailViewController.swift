//
//  PoliceCheckDetailViewController.swift
//  Flits
//
//  Created by Jakob Lierman on 07/01/2019.
//  Copyright © 2019 Jakob Lierman. All rights reserved.
//

import UIKit
import Firebase

class PoliceCheckDetailViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var image: UIImageView!
    // Firebase
    let db = Firestore.firestore()
    
    var policeCheck: PoliceCheck? {
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
        locationText.text = policeCheck?.location
        if (policeCheck?.descriptionText!.isEmpty)! {
            descriptionText.text = "-"
        } else {
            descriptionText.text = policeCheck?.descriptionText
        }
        // Get image
        if !(policeCheck?.imagePath!.isEmpty)! {
            let storageRef = Storage.storage().reference(forURL: "gs://flits-hogent.appspot.com")
            let imageRef = storageRef.child((policeCheck?.imagePath)!)
            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    print("error while getting image: \(error.localizedDescription)")
                } else {
                    self.image.image = UIImage(data: data!)
                }
            }
        }
        // Enable delete functionality if user is creator
        if Auth.auth().currentUser?.uid == policeCheck?.userID {
            deleteButton.isEnabled = true
        }
    }
    
    // MARK: - Actions
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        if Auth.auth().currentUser?.uid == policeCheck?.userID {
            // Show confirmation alert
            let alertController = UIAlertController(title: "Controle verwijderen", message: "Bent u zeker?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Annuleren", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Verwijderen", style: .destructive, handler: { (UIAlertAction) in
                // Delete item from database
                self.db.collection("policeChecks").document(self.policeCheck!.id).delete() { err in
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

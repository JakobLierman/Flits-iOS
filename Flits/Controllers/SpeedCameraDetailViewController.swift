//
//  SpeedCameraDetailViewController.swift
//  Flits
//
//  Created by Jakob Lierman on 06/01/2019.
//  Copyright © 2019 Jakob Lierman. All rights reserved.
//

import UIKit
import Firebase

class SpeedCameraDetailViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var kindText: UILabel!
    @IBOutlet weak var image: UIImageView!
    private var hasImage: Bool = false
    // Firebase
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference(forURL: "gs://flits-hogent.appspot.com")

    var speedCamera: SpeedCamera? {
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
        locationText.text = speedCamera?.location
        if (speedCamera?.descriptionText!.isEmpty)! {
            descriptionText.text = "-"
        } else {
            descriptionText.text = speedCamera?.descriptionText
        }
        kindText.text = speedCamera?.kind
        // Get image
        if speedCamera!.imagePath != nil {
            if !(speedCamera?.imagePath?.isEmpty)! {
                hasImage = true
                let imageRef = storageRef.child((speedCamera?.imagePath)!)
                imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        // Uh-oh, an error occurred!
                        print("error while getting image: \(error.localizedDescription)")
                    } else {
                        self.image.image = UIImage(data: data!)
                    }
                }
            }
        }
        // Enable delete functionality if user is creator
        if Auth.auth().currentUser?.uid == speedCamera?.userID {
            deleteButton.isEnabled = true
        }
    }

    // MARK: - Actions
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func deleteAction(_ sender: Any) {
        if Auth.auth().currentUser?.uid == speedCamera?.userID {
            // Show confirmation alert
            let alertController = UIAlertController(title: "Flitser verwijderen", message: "Bent u zeker?", preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "Annuleren", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Verwijderen", style: .destructive, handler: { (UIAlertAction) in
                // Delete item from database
                self.db.collection("speedCameras").document(self.speedCamera!.id).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document removed")
                        // Remove image from Firebase storage
                        if self.hasImage {
                            self.storageRef.child(self.speedCamera!.imagePath!).delete { err in
                                if let err = err {
                                    print("Error removing image: \(err)")
                                } else {
                                    print("Image removed")
                                }
                            }
                        }
                    }
                }
                // Close screen
                self.dismiss(animated: true, completion: nil)
            })

            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)

            self.present(alertController, animated: true, completion: nil)
        }
    }

}

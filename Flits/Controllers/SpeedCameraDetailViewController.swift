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
    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var kindText: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var speedCamera: SpeedCamera? {
        didSet {
            refreshUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func refreshUI() {
        loadViewIfNeeded()
        locationText.text = speedCamera?.location
        if (speedCamera?.descriptionText!.isEmpty)! {
            descriptionText.text = "-"
        } else {
            descriptionText.text = speedCamera?.descriptionText
        }
        kindText.text = speedCamera?.kind
        // Get image
        if !(speedCamera?.imagePath!.isEmpty)! {
            let storageRef = Storage.storage().reference(forURL: "gs://flits-hogent.appspot.com")
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
    
    // MARK: - Actions
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

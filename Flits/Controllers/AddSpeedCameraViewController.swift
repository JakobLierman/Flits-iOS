//
//  AddSpeedCameraViewController.swift
//  Flits
//
//  Created by Jakob Lierman on 24/12/2018.
//  Copyright © 2018 Jakob Lierman. All rights reserved.
//

import UIKit
import Firebase

class AddSpeedCameraViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var speedCameraKindPicker: UIPickerView!
    var speedCameraKindPickerData: [String] = [String]()
    var speedCameraKind: String!
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var selectImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // Connect data:
        self.speedCameraKindPicker.delegate = self
        self.speedCameraKindPicker.dataSource = self

        // Input the data into the array
        speedCameraKindPickerData = ["Vaste flitspaal", "Mobiele radar", "Flitsauto", "Lidar (superflitspaal)"]
        
        // Init imagePicker
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
    }

    // MARK: Actions
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveAction(_ sender: Any) {
        // Create new SpeedCamera instance
        let speedCamera: SpeedCamera = SpeedCamera.init(location: locationTextField.text!, kind: speedCameraKind!, description: descriptionTextField.text)
        // Write instance to database
        
        // Get item ID
        //let itemId // TODO
        
        // Create imagePath and imageName
        //let imagePath = "images/\(itemId).jpg"
        
        // Upload image
        // TODO
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func selectImageAction(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return speedCameraKindPickerData.count
    }

    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        speedCameraKind = speedCameraKindPickerData[row]
        return speedCameraKind
    }

    // Select image and show in imageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            
            // Change button and image settings
            selectImageButton.setTitle("", for: .normal)
            imageView.contentMode = .scaleAspectFit
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

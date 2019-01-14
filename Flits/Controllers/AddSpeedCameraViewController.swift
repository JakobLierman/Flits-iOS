//
//  AddSpeedCameraViewController.swift
//  Flits
//
//  Created by Jakob Lierman on 24/12/2018.
//  Copyright © 2018 Jakob Lierman. All rights reserved.
//

import UIKit
import Firebase

class AddSpeedCameraViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var speedCameraKindPicker: UIPickerView!
    var speedCameraKindPickerData: [String] = [String]()
    var speedCameraKind: String!
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var selectImageButton: UIButton!
    weak var activeField: UITextField?
    var hasImage: Bool = false
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!

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

        // Add observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        // Remove observer
        NotificationCenter.default.removeObserver(keyboardWillShow)
        NotificationCenter.default.removeObserver(keyboardWillHide)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeField = nil
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
    }

    // Change size of scrollView and scroll to field
    @objc func keyboardWillShow(notification: NSNotification) {
        if let activeField = self.activeField, let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            if (!aRect.contains(activeField.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }

    // Undo the above
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }

    // MARK: Actions
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveAction(_ sender: Any) {
        if validForm() {
            // Create new SpeedCamera instance
            let speedCamera: SpeedCamera = SpeedCamera.init(location: locationTextField.text!, kind: speedCameraKind!, descriptionText: descriptionTextField.text)
            // Write instance to database
            let documentReference = speedCamera.toDatabase()

            // Get item ID
            let itemId = documentReference.documentID

            if hasImage {
                // Create imagePath
                let imagePath = "images/speedCameras/\(itemId).jpg"
                // Upload image
                uploadImage(image: imageView.image!, path: imagePath)
                speedCamera.addImagePath(path: imagePath)
            }

            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func selectImageAction(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }

    // Upload image
    private func uploadImage(image: UIImage, path: String) {
        let storageRef = Storage.storage().reference(forURL: "gs://flits-hogent.appspot.com")
        var data = NSData()
        data = image.jpegData(compressionQuality: 0.8)! as NSData
        let childImages = storageRef.child(path)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        // Upload
        childImages.putData(data as Data, metadata: metaData)
    }

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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            hasImage = true

            // Change button and image settings
            selectImageButton.setTitle("", for: .normal)
            imageView.contentMode = .scaleAspectFit
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    // Check if form is valid
    private func validForm() -> Bool {
        var isValid: Bool = true

        // Check location
        locationLabel.textColor = UIColor.black
        if locationTextField.text!.isEmpty {
            locationLabel.textColor = UIColor.red
            isValid = false
        }
        // Check kind
        kindLabel.textColor = UIColor.black
        if speedCameraKind!.isEmpty {
            kindLabel.textColor = UIColor.red
            isValid = false
        }

        if !isValid {
            // Show alert if form is not filled in correctly
            let alertController = UIAlertController(title: "Oeps", message: "Niet alle velden zijn correct ingevuld", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }

        return isValid
    }
    
}

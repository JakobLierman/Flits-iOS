//
//  AddPoliceCheckViewController.swift
//  Flits
//
//  Created by Jakob Lierman on 24/12/2018.
//  Copyright © 2018 Jakob Lierman. All rights reserved.
//

import UIKit
import Firebase

class AddPoliceCheckViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var selectImageButton: UIButton!
    weak var activeField: UITextField?
    var hasImage: Bool = false
    @IBOutlet weak var locationLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

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

    // Select image and show in imageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            hasImage = true

            // Change button and image settings
            selectImageButton.setTitle("", for: .normal)
            imageView.contentMode = .scaleAspectFit
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    // MARK: - Actions
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveAction(_ sender: Any) {
        if validForm() {
            // Create new PoliceCheck instance
            let policeCheck: PoliceCheck = PoliceCheck.init(location: locationTextField.text!, descriptionText: descriptionTextField.text)
            // Write instance to database
            let documentReference = policeCheck.toDatabase()

            // Get item ID
            let itemId = documentReference.documentID

            if hasImage {
                // Create imagePath
                let imagePath = "images/policeChecks/\(itemId).jpg"
                // Upload image
                uploadImage(image: imageView.image!, path: imagePath)
                policeCheck.addImagePath(path: imagePath)
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
        let childUserImages = storageRef.child(path)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        // Upload
        childUserImages.putData(data as Data, metadata: metaData)
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

        if !isValid {
            // Show alert if form is not filled in correctly
            let alertController = UIAlertController(title: "Oeps", message: "Niet alle velden zijn correct ingevuld", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }

        return isValid
    }

}

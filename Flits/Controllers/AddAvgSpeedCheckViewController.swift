//
//  AddAvgSpeedCheckViewController.swift
//  Flits
//
//  Created by Jakob Lierman on 24/12/2018.
//  Copyright © 2018 Jakob Lierman. All rights reserved.
//

import UIKit

class AddAvgSpeedCheckViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var beginLocationTextField: UITextField!
    @IBOutlet weak var endLocationTextField: UITextField!
    weak var activeField: UITextField?
    @IBOutlet weak var beginLocationLabel: UILabel!
    @IBOutlet weak var endLocationLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

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
            // Create new AvgSpeedCheck instance
            let avgSpeedCheck: AvgSpeedCheck = AvgSpeedCheck.init(beginLocation: beginLocationTextField.text!, endLocation: endLocationTextField.text!)
            // Write instance to database
            avgSpeedCheck.toDatabase()

            self.dismiss(animated: true, completion: nil)
        }
    }

    // Check if form is valid
    private func validForm() -> Bool {
        var isValid: Bool = true

        // Check beginLocation
        beginLocationLabel.textColor = UIColor.black
        if beginLocationTextField.text!.isEmpty {
            beginLocationLabel.textColor = UIColor.red
            isValid = false
        }
        // Check endLocation
        endLocationLabel.textColor = UIColor.black
        if endLocationTextField.text!.isEmpty {
            endLocationLabel.textColor = UIColor.red
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

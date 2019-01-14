//
//  SignupViewController.swift
//  Flits
//
//  Created by Jakob Lierman on 20/12/2018.
//  Copyright © 2018 Jakob Lierman. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    weak var activeField: UITextField?

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

    // MARK: - Actions
    @IBAction func signUpAction(_ sender: UIButton) {
        if validForm() {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error == nil {
                    // Save user data to database
                    let db = Firestore.firestore()
                    db.collection("users").document(user!.user.uid).setData(["fullName": self.fullNameTextField.text!])
                    { err in
                        // Error adding user to database
                        if let err = err {
                            print("Error adding document: \(err)")
                        }
                    }

                    // Go to next view
                    self.performSegue(withIdentifier: "signupToHome", sender: self)
                } else {
                    // Error creating user
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)

                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

    // MARK: - Controlling the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // Check if form is valid
    private func validForm() -> Bool {
        var isValid: Bool = true

        // Check name
        fullNameLabel.textColor = UIColor.black
        if fullNameTextField.text!.isEmpty {
            fullNameLabel.textColor = UIColor.red
            isValid = false
        }

        // Check email
        emailLabel.textColor = UIColor.black
        if emailTextField.text!.isEmpty {
            emailLabel.textColor = UIColor.red
            isValid = false
        }

        // Check password
        passwordLabel.textColor = UIColor.black
        if passwordTextField.text!.isEmpty {
            passwordLabel.textColor = UIColor.red
            isValid = false
        }

        if !isValid {
            // Show alert if form is not filled in correctly
            let alertController = UIAlertController(title: "Oeps", message: "Niet alle velden zijn correct ingevuld", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            // Check if passwords match
            if passwordTextField.text != passwordConfirmTextField.text {
                passwordLabel.textColor = UIColor.red
                // Show alert
                let alertController = UIAlertController(title: "Wachtwoorden komen niet overeen", message: "Gelieve uw wachtwoord opnieuw in te geven", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)

                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                isValid = false
            }
        }

        return isValid
    }

}

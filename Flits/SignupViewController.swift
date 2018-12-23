//
//  SignupViewController.swift
//  Flits
//
//  Created by Jakob Lierman on 20/12/2018.
//  Copyright © 2018 Jakob Lierman. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Actions
    @IBAction func signUpAction(_ sender: UIButton) {
        // Check if passwords match
        if passwordTextField.text != passwordConfirmTextField.text {
            let alertController = UIAlertController(title: "Wachtwoorden komen niet overeen", message: "Gelieve uw wachtwoord opnieuw in te geven", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!){ (user, error) in
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  AddPoliceCheckViewController.swift
//  Flits
//
//  Created by Jakob Lierman on 24/12/2018.
//  Copyright © 2018 Jakob Lierman. All rights reserved.
//

import UIKit

class AddPoliceCheckViewController: UIViewController {
    
    // MARK: Properties

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Actions
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        // TODO - Implement
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

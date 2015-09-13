//
//  HomeController.swift
//  BuildIt!
//
//  Created by Srihari Mohan on 9/12/15.
//  Copyright (c) 2015 Srihari Mohan. All rights reserved.
//

import Foundation
import UIKit

class HomeController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var sproutButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = UIImage(named: "homeScreen")
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true;
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = " "
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    @IBAction func goToMap(sender: UIButton) {
        if self.usernameTextField.text.isEmpty || self.passwordTextField.text.isEmpty {
            let alertVC = UIAlertController(title: "Both Username and Password required to access Sprout", message: "Please input all required fields", preferredStyle: .Alert)
            let alert_action = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
            alertVC.addAction(alert_action)
            self.presentViewController(alertVC, animated: true, completion: nil)
        } else {
            self.performSegueWithIdentifier("segueFromHomeScreenToMap", sender: self)
        }
    }
    
}

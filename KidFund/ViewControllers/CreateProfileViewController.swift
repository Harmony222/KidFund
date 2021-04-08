//
//  CreateProfileViewController.swift
//  KidFund
//
//  Created by Harmony Scarlet on 4/8/21.
//

import UIKit
import Parse

class CreateProfileViewController: UIViewController {
    var username: String? = nil
    var password: String? = nil
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.username != "" {
            usernameField.text = username
        }
        if self.password != "" {
            passwordField.text = password
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCreateProfileButton(_ sender: Any) {
        let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        user["firstName"] = firstNameField.text
        user["lastName"] = lastNameField.text

        user.signUpInBackground { (success, error) in
            if success {
                print("made account")
                self.dismiss(animated: true, completion: nil)
//                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
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

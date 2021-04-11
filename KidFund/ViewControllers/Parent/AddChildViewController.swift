//
//  AddChildViewController.swift
//  KidFund
//
//  Created by Harmony Scarlet on 4/8/21.
//

import UIKit
import Parse

class AddChildViewController: UIViewController {

    @IBOutlet weak var childNameField: UITextField!
    @IBOutlet weak var childAgeField: UITextField!
    @IBOutlet weak var childFundsField: UITextField!
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSaveButton(_ sender: Any) {
        let childName = childNameField.text!
        let childAge = childAgeField.text!
        let childFunds = childFundsField.text!
        
        let child = PFObject(className: "Children")
        
        child["name"] = childName
        child["age"] = Int(childAge)
        child["parent"] = PFUser.current()!
        child["total"] = Double(childFunds)
        
        child.saveInBackground { (success, error) in
            if success {
                print("child added!")
            } else {
                print("error adding child")
            }
        }
        childNameField.text = ""
        childAgeField.text = ""
        childFundsField.text = ""
        leftBarButton.title = "Done"
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

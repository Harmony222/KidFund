//
//  EditGoalViewController.swift
//  KidFund
//
//  Created by Harmony Scarlet on 4/10/21.
//

import UIKit
import Parse

class EditGoalViewController: UIViewController {
    
    var childGoal = PFObject(className: "ChildGoals");

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var amountField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let child = childGoal["child"] as! PFObject
        let childName = child["name"] as! String
        print(childName)
        titleLabel.text = childName
        
        let goal = childGoal["goal"] as! PFObject
        let description = goal["description"] as! String
        taskTitleLabel.text = description
        let amount = childGoal["customAmount"] as! Double
        print(amount, description)
        amountField.text = String(format: "%.2f", amount)

    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSaveChangesButton(_ sender: Any) {
        let newAmountStr = amountField.text!
        var newAmount: Double = 0.0
        if newAmountStr != "" {
            newAmount = Double(newAmountStr)!
        }
        print(newAmount)
        
        childGoal["customAmount"] = newAmount
        childGoal.saveInBackground { (success, error) in
            if success {
                print("childGoal updated!")
                self.dismiss(animated: true, completion: nil)
            } else {
                print("error updating childGoal")
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

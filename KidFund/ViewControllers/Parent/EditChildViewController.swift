//
//  EditChildViewController.swift
//  KidFund
//
//  Created by Harmony Scarlet on 4/10/21.
//

import UIKit
import Parse

class EditChildViewController: UIViewController {
    
    var selectedChild = PFObject(className: "Children");
    @IBOutlet weak var childNameLabel: UILabel!
    @IBOutlet weak var childNameField: UITextField!
    @IBOutlet weak var childAgeField: UITextField!
    @IBOutlet weak var currentFundsLabel: UILabel!
    @IBOutlet weak var adjustmentAmountField: UITextField!
    @IBOutlet weak var newFundsLabel: UILabel!
    @IBOutlet weak var segControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = selectedChild["name"] as! String
        print(name)
        childNameLabel.text = "Editing " + name
        childNameField.text = name
        childAgeField.text = String(selectedChild["age"] as! Int)
        let total = selectedChild["total"] as! Double
        currentFundsLabel.text = String(format: "$%.2f", total)
        newFundsLabel.text = String(format: "$%.2f", total)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func calculateNewTotal(_ sender: Any) {
        let prevTotal = selectedChild["total"] as! Double
        let adjustmentAmount = Double(adjustmentAmountField.text!) ?? 0
        let signAdjuster = [1, -1]
        let newTotal = Double(signAdjuster[segControl.selectedSegmentIndex]) * adjustmentAmount + prevTotal
        newFundsLabel.text = String(format: "$%.2f", newTotal)
    }
    
    @IBAction func onSaveChanges(_ sender: Any) {
        
        var childName = childNameField.text
        let childAge = Int(childAgeField.text!) ?? selectedChild["age"] as! Int
        if childName == "" {
            childName = (selectedChild["name"] as! String)
        }
        
        let prevTotal = selectedChild["total"] as! Double
        let adjustmentAmount = Double(adjustmentAmountField.text!) ?? 0
        let signAdjuster = [1, -1]
        var newTotal = Double(signAdjuster[segControl.selectedSegmentIndex]) * adjustmentAmount + prevTotal
        // check for negative numbers
        if newTotal < 0 {
            newTotal = 0
        }
        // update child in database
        selectedChild["name"] = childName
        selectedChild["age"] = childAge
        selectedChild["total"] = newTotal
        selectedChild.saveInBackground { (success, error) in
            if success {
                print("child info updated!")
                self.dismiss(animated: true, completion: nil)
            } else {
                print("error updating child info")
                let alert = Utils.createAlert("Error updating child info.")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func onCancelButton(_ sender: Any) {
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

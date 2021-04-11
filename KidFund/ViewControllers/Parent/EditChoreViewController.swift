//
//  EditChoreViewController.swift
//  KidFund
//
//  Created by Harmony Scarlet on 4/10/21.
//

import UIKit
import Parse

class EditChoreViewController: UIViewController {
    
    var childChore = PFObject(className: "ChildChore");

    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let child = childChore["child"] as! PFObject
        let childName = child["name"] as! String
        titleLabel.text = childName
        
        let chore = childChore["chore"] as! PFObject
        let description = chore["description"] as! String
        taskTitleLabel.text = description
        let amount = childChore["customAmount"] as! Double

        amountField.text = String(format: "%.2f", amount)
        
        
        // Do any additional setup after loading the view.
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
        
        childChore["customAmount"] = newAmount
        childChore.saveInBackground { (success, error) in
            if success {
                print("childChore updated!")
                self.dismiss(animated: true, completion: nil)
            } else {
                print("error updating childChore")
            }
        }
        
    }
    
    @IBAction func onDeleteButton(_ sender: Any) {
        childChore.deleteInBackground() { (success, error) in
            if success {
                let alert = UIAlertController(title: "", message: "Task deleted.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                
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

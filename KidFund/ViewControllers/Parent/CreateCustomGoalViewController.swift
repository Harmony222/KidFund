//
//  CreateCustomGoalViewController.swift
//  KidFund
//
//  Created by Harmony Scarlet on 4/10/21.
//

import UIKit
import Parse

class CreateCustomGoalViewController: UIViewController {
    
    var selectedChild = PFObject(className: "Children");
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCreateGoalButton(_ sender: Any) {
        let description = descriptionField.text! as String
        let amount = Double(amountField.text!)
        print(description, amount!)
        let image = UIImage(named: "checklist")
        
        let goal = PFObject(className: "Goals")
        
        goal["description"] = description
        goal["amount"] = amount
        
        let imageData = image!.pngData()!
        let file = PFFileObject(name: "image.png", data: imageData)
        
        goal["image"] = file
        
        goal.saveInBackground { (success, error) in
            if success {
                print("goal created!")
            } else {
                print("error creating goal")
            }
        }
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

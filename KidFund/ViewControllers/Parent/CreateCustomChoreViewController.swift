//
//  CreateCustomChoreViewController.swift
//  KidFund
//
//  Created by Harmony Scarlet on 4/11/21.
//

import UIKit
import Parse

class CreateCustomChoreViewController: UIViewController {
    
    var selectedChild = PFObject(className: "Children");
    
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCreateTaskButton(_ sender: Any) {
        let description = descriptionField.text! as String
        let amount = Double(amountField.text!)
        print(description, amount!)
        let image = UIImage(systemName: "sparkles")
        
        let chore = PFObject(className: "Chores")
        
        chore["description"] = description
        chore["amount"] = amount
        
        let imageData = image!.pngData()!
        let file = PFFileObject(name: "image.png", data: imageData)
        
        chore["image"] = file
        
        chore.saveInBackground { (success, error) in
            if success {
                print("goal created!")
                self.dismiss(animated: true, completion: nil)
            } else {
                print("error creating goal")
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

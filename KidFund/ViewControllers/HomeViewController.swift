//
//  HomeViewController.swift
//  KidFund
//
//  Created by Harmony Scarlet on 4/8/21.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var childrenCollectionView: UICollectionView!
    
    @IBOutlet weak var greetingLabel: UILabel!
 
    @IBOutlet weak var parentButton: CustomButton!
    
    var userChildren = [PFObject]()
    var numberOfCells: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = PFUser.current()!
        let lastName = user["lastName"] as! String
        let greeting = "Welcome " + lastName + " Family!"
        greetingLabel.text = greeting
        let firstName = user["firstName"] as! String
        let buttonString = firstName + "\nParent"
        Utils.formatButton(button: parentButton, textString: buttonString)
        
        childrenCollectionView.delegate = self
        childrenCollectionView.dataSource = self
             
        // setup children collection view layout
        let layout = childrenCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 40
        layout.minimumInteritemSpacing = 40

        layout.itemSize = CGSize(width: 80, height: 80)
        // Do any additional setup after loading the view.
        
        // Get children of parent from database
        let query = PFQuery(className: "Children")
        query.whereKey("parent", equalTo: PFUser.current()!)
        query.includeKeys(["name", "age"])
        query.findObjectsInBackground { (userChildren, error) in
            if userChildren != nil {
                self.userChildren = userChildren!
                self.childrenCollectionView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onParentButton(_ sender: Any) {
        let alertController = UIAlertController(title: "", message: "Please enter account password.", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            let textField = alertController.textFields![0] as UITextField
                print(textField.text!)
            let password = textField.text!
            let user = PFUser.current()
            let username = user?.username!
            PFUser.logInWithUsername(inBackground: username!, password: password) { (user, error) in
                if user != nil {
                    self.performSegue(withIdentifier: "parentLoginSegue", sender: nil)
                } else {
                    print("Error: \(String(describing: error?.localizedDescription))")
                    let alert = UIAlertController(title: "", message: "Incorrect password.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }))

        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userChildren.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChildCollectionViewCell", for: indexPath) as! ChildCollectionViewCell
        let userChild = userChildren[indexPath.item]
        let childAge = userChild["age"] as! Int

        let childName = userChild["name"] as! String
        cell.childNameLabel.text = childName
        cell.childAgeLabel.text = "Age " + String(childAge)
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true

        
        return cell
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



class Utils {
    static func formatButton(button: CustomButton, textString: String) {
        // https://stackoverflow.com/questions/30679370/swift-uibutton-with-two-lines-of-text
        //applying the line break mode
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        let buttonText: NSString = textString as NSString

        //getting the range to separate the button title strings
        let newlineRange: NSRange = buttonText.range(of: "\n")
        //getting both substrings
        var substring1 = ""
        var substring2 = ""

        if(newlineRange.location != NSNotFound) {
            substring1 = buttonText.substring(to: newlineRange.location)
            substring2 = buttonText.substring(from: newlineRange.location)
        }

        //assigning diffrent fonts to both substrings
        let font1: UIFont = UIFont(name: "Arial", size: 17.0)!
        let attributes1 = [NSMutableAttributedString.Key.font: font1]
        let attrString1 = NSMutableAttributedString(string: substring1, attributes: attributes1)

        let font2: UIFont = UIFont(name: "Arial", size: 12.0)!
        let attributes2 = [NSMutableAttributedString.Key.font: font2]
        let attrString2 = NSMutableAttributedString(string: substring2, attributes: attributes2)

        //appending both attributed strings
        attrString1.append(attrString2)

        //assigning the resultant attributed strings to the button
        button.setAttributedTitle(attrString1, for: [])
        button.titleLabel?.textAlignment = .center
    }
}

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
//        layout.minimumLineSpacing = 20
//        layout.minimumInteritemSpacing = 20
//
        layout.itemSize = CGSize(width: 120, height: 120)
        
        // Get children of parent from database
        getChildren()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getChildren()
    }
    
    func getChildren() {
        let query = PFQuery(className: "Children")
        query.whereKey("parent", equalTo: PFUser.current()!)
        query.includeKeys(["name", "age"])
        query.findObjectsInBackground { (userChildren, error) in
            if userChildren != nil {
                self.userChildren = userChildren!
                self.childrenCollectionView.reloadData()
            }
        }
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

    
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")

        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        
        delegate.window?.rootViewController = loginViewController
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "childHomeSegue" {
            print("loading child home")
            let cell = sender as! UICollectionViewCell
            let indexPath = childrenCollectionView.indexPath(for: cell)!
            let selectedChild = userChildren[indexPath.item]
//            print(selectedChild["name"]!)
            let childHomeViewController = segue.destination as! ChildHomeViewController
            childHomeViewController.selectedChild = selectedChild
            
            childrenCollectionView.deselectItem(at: indexPath, animated: true)
            
        }
    }
    
}

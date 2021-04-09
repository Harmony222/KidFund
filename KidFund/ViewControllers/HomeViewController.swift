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
    @IBOutlet weak var parentNameLabel: UILabel!
    
    @IBOutlet weak var parentView: UIView!
    
    var userChildren = [PFObject]()
    var numberOfCells: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = PFUser.current()!
        let lastName = user["lastName"] as! String
        let greeting = "Welcome " + lastName + " Family!"
        greetingLabel.text = greeting
        let firstName = user["firstName"] as! String
        parentNameLabel.text = firstName
        childrenCollectionView.delegate = self
        childrenCollectionView.dataSource = self
             
        // setup children collection view layout
        let layout = childrenCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 40
        layout.minimumInteritemSpacing = 40

        layout.itemSize = CGSize(width: 80, height: 80)
        parentView.layer.cornerRadius = 10
        parentView.layer.masksToBounds = true
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

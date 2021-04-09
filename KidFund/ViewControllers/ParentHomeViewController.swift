//
//  ParentHomeViewController.swift
//  KidFund
//
//  Created by Harmony Scarlet on 4/8/21.
//

import UIKit
import Parse

class ParentHomeViewController: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate {

    
    
    var userChildren = [PFObject]()
    var numberOfCells: Int!
    
    @IBOutlet weak var childrenCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        childrenCollectionView.delegate = self
        childrenCollectionView.dataSource = self
        
        let layout = childrenCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 40
        layout.minimumInteritemSpacing = 40

        layout.itemSize = CGSize(width: 120, height: 120)
        // Do any additional setup after loading the view.
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

    @IBAction func onBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "parentChildDetailsSegue" {
            print("loading parent child details")
            let cell = sender as! UICollectionViewCell
            let indexPath = childrenCollectionView.indexPath(for: cell)!
            let selectedChild = userChildren[indexPath.item]
//            print(selectedChild["name"]!)
            let parentChildDetailsViewController = segue.destination as! ParentChildDetailsViewController
            parentChildDetailsViewController.selectedChild = selectedChild
            
            childrenCollectionView.deselectItem(at: indexPath, animated: true)
            
        }
    }
    

}

//
//  ParentChildDetailsViewController.swift
//  KidFund
//
//  Created by Harmony Scarlet on 4/8/21.
//

import UIKit
import Parse

class ParentChildDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {

    
    
    var selectedChild = PFObject(className: "Children");
    @IBOutlet weak var childNameLabel: UILabel!
    var childChores = [PFObject]()
    
    @IBOutlet weak var choreCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = selectedChild["name"]
        childNameLabel.text = name as? String
        choreCollectionView.delegate = self
        choreCollectionView.dataSource = self
        
//        self.childChores = selectedChild["chores"] as! [PFObject]
//        for chore in childChores {
//            print(chore)
//        }
  

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getChores()
    }
    
    func getChores() {
        let query = PFQuery(className: "ChildChores")
        query.whereKey("child", equalTo: selectedChild)
        query.includeKeys(["chore", "chore.description", "chore.amount", "chore.image"])
        query.findObjectsInBackground { (chores, error) in
            if chores != nil {
                self.childChores = chores!
                self.choreCollectionView.reloadData()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childChores.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChoreCollectionViewCell", for: indexPath) as! ChoreCollectionViewCell

        let ChildChore = self.childChores[indexPath.item] as PFObject
        print(ChildChore)
        
        let chore = ChildChore["chore"] as! PFObject
        print(chore)
        
//        let comments = (post["comments"] as? [PFObject]) ?? []
        let description = chore["description"] as! String
        let amount = chore["amount"] as! Double

        cell.choreDescription.text = description
        cell.choreAmount.text = String(format: "$%.2f", amount)


        let imageFile = chore["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        cell.choreImageView.af.setImage(withURL: url)


        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addChoresSegue" {
            print("loading add chores")

//            print(selectedChild["name"]!)
            let addChoresViewController = segue.destination as! AddChoresViewController
            addChoresViewController.selectedChild = selectedChild
            
            
        }
    }
    

}

//
//  ChildGoalsViewController.swift
//  KidFund
//
//  Created by Harmony Scarlet on 4/10/21.
//

import UIKit
import Parse
import AVFoundation

class ChildGoalsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    var selectedChild = PFObject(className: "Children");
    var childGoals = [PFObject]()
    
    @IBOutlet weak var childName: UILabel!
    @IBOutlet weak var goalsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = selectedChild["name"]
        print(name!)
        childName.text = (name as? String)! + "'s Goals"
        goalsCollectionView.delegate = self
        goalsCollectionView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getGoals()
    }
    
    func getGoals() {
        let query = PFQuery(className: "ChildGoals")
        query.whereKey("child", equalTo: selectedChild)
        query.includeKeys(["goal", "goal.description", "goal.amount", "goal.image"])
        query.findObjectsInBackground { (goals, error) in
            if goals != nil {
                self.childGoals = goals!
                self.goalsCollectionView.reloadData()
            }
        }
    }
      
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childGoals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GoalCollectionViewCell", for: indexPath) as! GoalCollectionViewCell

        let ChildGoal = self.childGoals[indexPath.item] as PFObject
        let goal = ChildGoal["goal"] as! PFObject
        
        let description = goal["description"] as! String
        let amount = goal["amount"] as! Double

        cell.goalDescriptionLabel.text = description
        cell.goalAmountLabel.text = String(format: "$%.2f", amount)

        let imageFile = goal["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        cell.goalImageView.af.setImage(withURL: url)

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

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
    var childGoals = [PFObject]()
    
    @IBOutlet weak var choreCollectionView: UICollectionView!
    @IBOutlet weak var goalsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = selectedChild["name"]
        childNameLabel.text = name as? String
        
        choreCollectionView.delegate = self
        choreCollectionView.dataSource = self

        goalsCollectionView.delegate = self
        goalsCollectionView.dataSource = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getChores()
        getGoals()
    }
    
    func getChores() {
        let query = PFQuery(className: "ChildChores")
        query.whereKey("child", equalTo: selectedChild)
        query.includeKeys(["customAmount", "chore", "chore.description", "chore.amount", "chore.image", "child", "child.name"])
        query.findObjectsInBackground { (chores, error) in
            if chores != nil {
                self.childChores = chores!
                self.choreCollectionView.reloadData()
            }
        }
    }
    
    func getGoals() {
        let query = PFQuery(className: "ChildGoals")
        query.whereKey("child", equalTo: selectedChild)
        query.includeKeys(["customAmount", "goal", "goal.description", "goal.amount", "goal.image", "child", "child.name"])
        query.findObjectsInBackground { (goals, error) in
            if goals != nil {
                self.childGoals = goals!
                self.goalsCollectionView.reloadData()
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.choreCollectionView {
            return childChores.count
        }
        return childGoals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.choreCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChoreCollectionViewCell", for: indexPath) as! ChoreCollectionViewCell
            
            let ChildChore = self.childChores[indexPath.item] as PFObject

            let chore = ChildChore["chore"] as! PFObject
            
            let description = chore["description"] as! String
            let customAmount = ChildChore["customAmount"] as! Double
            
            cell.choreDescription.text = description
            cell.choreAmount.text = String(format: "$%.2f", customAmount)

            let imageFile = chore["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            cell.choreImageView.af.setImage(withURL: url)

            cell.editButton.tag = indexPath.item
            cell.editButton.addTarget(self, action: #selector(editChoreButton), for: .touchUpInside)

            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GoalCollectionViewCell", for: indexPath) as! GoalCollectionViewCell

        let ChildGoal = self.childGoals[indexPath.item] as PFObject
        let goal = ChildGoal["goal"] as! PFObject
        
        let description = goal["description"] as! String
        let amount = ChildGoal["customAmount"] as! Double

        cell.goalDescriptionLabel.text = description
        cell.goalAmountLabel.text = String(format: "$%.2f", amount)

        let imageFile = goal["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        cell.goalImageView.af.setImage(withURL: url)

        cell.editButton.tag = indexPath.item
        cell.editButton.addTarget(self, action: #selector(editGoalButton), for: .touchUpInside)
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
    
    @objc func editChoreButton(sender:UIButton) {
        self.performSegue(withIdentifier: "editChoreSegue", sender: sender)
    }
    
    @objc func editGoalButton(sender:UIButton) {
        self.performSegue(withIdentifier: "editGoalSegue", sender: sender)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addChoresSegue" {
            print("loading add chores")
            let addChoresViewController = segue.destination as! AddChoresViewController
            addChoresViewController.selectedChild = selectedChild
                      
        }
        if segue.identifier == "addGoalsSegue" {
            print("loading add goals")
            let addGoalsViewController = segue.destination as! AddGoalsViewController
            addGoalsViewController.selectedChild = selectedChild
                      
        }
        if segue.identifier == "editChildSegue" {
            print("loading edit child")
            let editChildViewController = segue.destination as! EditChildViewController
            editChildViewController.selectedChild = selectedChild
                      
        }
        if segue.identifier == "editChoreSegue" {
            print("loading edit chore")
            // https://stackoverflow.com/questions/52352530/how-to-pass-uibuttons-tag-an-int-to-other-viewcontroller-using-prepareforsegu
            let destinationVC = segue.destination as! EditChoreViewController
            if let button = sender as? UIButton {
                let indexPath = IndexPath(item: button.tag, section: 0)
                let ChildChore = self.childChores[indexPath.item] as PFObject
                destinationVC.childChore = ChildChore
            }
        }
        if segue.identifier == "editGoalSegue" {
            print("loading edit goal")
            let destinationVC = segue.destination as! EditGoalViewController
            if let button = sender as? UIButton {
                let indexPath = IndexPath(item: button.tag, section: 0)
                let ChildGoal = self.childGoals[indexPath.item] as PFObject
                destinationVC.childGoal = ChildGoal
            }
        }
    }

    
}

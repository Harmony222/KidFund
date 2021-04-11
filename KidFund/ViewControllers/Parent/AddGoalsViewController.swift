//
//  AddGoalsViewController.swift
//  KidFund
//
//  Created by Harmony Scarlet on 4/9/21.
//

import UIKit
import Parse
import AlamofireImage

class AddGoalsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var goalsCollectionView: UICollectionView!
    var selectedChild = PFObject(className: "Children");
    @IBOutlet weak var greetingLabel: UILabel!
    var goals = [PFObject]()
    var selectedGoals = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(selectedChild["name"]!)
        let childName = selectedChild["name"] as! String
        greetingLabel.text = "Adding goals for " + childName

        goalsCollectionView.delegate = self
        goalsCollectionView.dataSource = self
        self.goalsCollectionView.allowsMultipleSelection = true
        self.goalsCollectionView.allowsMultipleSelectionDuringEditing = true
        
        let query = PFQuery(className: "Goals")
//        query.whereKeyDoesNotExist("child")
        query.includeKeys(["description", "amount", "image"])
        query.findObjectsInBackground { (goals, error) in
            if goals != nil {
                self.goals = goals!
                self.goalsCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GoalCollectionViewCell", for: indexPath) as! GoalCollectionViewCell
        let goal = goals[indexPath.item]
        let description = goal["description"] as! String
        let amount = goal["amount"] as! Double
        
        cell.goalDescriptionLabel.text = description
        cell.goalAmountLabel.text = String(format: "$%.2f", amount)
        
        
        let imageFile = goal["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        cell.goalImageView.af.setImage(withURL: url)
        
        if cell.isSelected {
            //put border logic
            cell.layer.borderColor = UIColor(named: "AppGreenBlue")?.cgColor
            cell.layer.borderWidth = 2
        } else {
            // remove border
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.borderWidth = 2
        }
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //https://stackoverflow.com/questions/49935711/adding-borders-on-collectionview-cell
        print(indexPath.item)
        let cell = collectionView.cellForItem(at: indexPath) as! GoalCollectionViewCell
        cell.layer.borderColor = UIColor(named: "AppGreenBlue")?.cgColor
        cell.layer.borderWidth = 2
        cell.isSelected = true
        let goal = goals[indexPath.item]
//        let customAmountStr = cell.customAmount.text ?? "0"
//        let customAmount = Double(customAmountStr)!
        // add chore to array when selected
        selectedGoals.append(goal)
//        customAmounts.append(customAmount)
    }


    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GoalCollectionViewCell
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 2
        cell.isSelected = false
        let goal = goals[indexPath.item]
        // remove chore from array upon deselect
        if let index = selectedGoals.firstIndex(of: goal) {
            selectedGoals.remove(at: index)
        }
    }
    
    @IBAction func onAddSelectedGoalsButton(_ sender: Any) {
        for selected in self.selectedGoals {
            print(selected["description"] as! String)
            
            // check ChildGoals for duplicate
            let query = PFQuery(className: "ChildGoals")
            query.whereKey("child", equalTo: selectedChild)
            query.whereKey("goal", equalTo: selected)
            

            query.findObjectsInBackground { (childGoals, error) in
                if childGoals!.count != 0 {
                    print(childGoals!)
                    print("child/goal is duplicate, not added")
                } else {
                    // if no duplicates, add Child + Goal to table
                    let goal = PFObject(className: "ChildGoals")
                    goal["child"] = self.selectedChild
                    goal["goal"] = selected
                    goal["customAmount"] = selected["amount"]
                    goal.saveInBackground { (success, error) in
                        if success {
                            print("child's goal added")
                            
                        } else {
                            print("error adding child's goal")
                        }
                    }
                }
            }
        }
        selectedGoals.removeAll()
        goalsCollectionView.deselectAllItems(animated: true)
        self.goalsCollectionView.reloadData()
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

//<a href='https://www.freepik.com/vectors/car'>Car vector created by macrovector - www.freepik.com</a>
// <a href='https://www.freepik.com/vectors/background'>Background vector created by brgfx - www.freepik.com</a>
//<a href='https://www.freepik.com/vectors/design'>Design vector created by freepik - www.freepik.com</a>
//<a href='https://www.freepik.com/vectors/background'>Background vector created by iconicbestiary - www.freepik.com</a>

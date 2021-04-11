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
    var fundsText = ""
    
    @IBOutlet weak var childName: UILabel!
    @IBOutlet weak var goalsCollectionView: UICollectionView!
    
    @IBOutlet weak var totalFundsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = selectedChild["name"]
        print(name!)
        childName.text = (name as? String)! + "'s Goals"
        
        let total = selectedChild["total"] as! Double
        self.fundsText = "You have" + Utils.translateFunds(total)
        totalFundsLabel.text = "Total Funds: " + String(format: "$%.2f", total)
        
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
        query.includeKeys(["customAmount", "goal", "goal.description", "goal.amount", "goal.image", "child", "child.name"])
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
        let amount = ChildGoal["customAmount"] as! Double

        cell.goalDescriptionLabel.text = description
        cell.goalAmountLabel.text = String(format: "$%.2f", amount)

        let imageFile = goal["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        cell.goalImageView.af.setImage(withURL: url)
        
        // Calculate progress and set progress bar, highlight cell if reached goal
        let totalFunds = selectedChild["total"] as! Double
        var progress = totalFunds / amount
        if progress > 1 {
            progress = 1
            cell.backgroundColor = UIColor(named: "AppHighlight") ?? UIColor.yellow
        }
        cell.progressBarView.progress = CGFloat(progress)

        // setup speaker buttons
        cell.speakerButton1.tag = indexPath.item
        cell.speakerButton1.addTarget(self, action: #selector(speakerButton1), for: .touchUpInside)

        cell.speakerButton2.tag = indexPath.item
        cell.speakerButton2.addTarget(self, action: #selector(speakerButton2), for: .touchUpInside)
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
    
    @objc func speakerButton1(sender:UIButton) {
        let indexpath1 = IndexPath(item: sender.tag, section: 0)

        let ChildGoal = self.childGoals[indexpath1.item] as PFObject
        let goal = ChildGoal["goal"] as! PFObject
        let description = goal["description"] as! String
        let amount = ChildGoal["customAmount"] as! Double
        let costText = "This costs" + Utils.translateFunds(amount)
        Utils.speak(description + ". " + costText)

    }
    
    @objc func speakerButton2(sender:UIButton) {
        Utils.speak("Your progress.")
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

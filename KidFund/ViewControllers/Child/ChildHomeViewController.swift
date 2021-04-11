//
//  ChildHomeViewController.swift
//  KidFund
//
//  Created by Harmony Scarlet on 4/8/21.
//

import UIKit
import Parse
import AVFoundation

class ChildHomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    
    var selectedChild = PFObject(className: "Children");
    var feedbackArray = [PFObject]()
    var greetingText = ""
    var fundsText = ""
    

    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var greetingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let childName = selectedChild["name"] as! String
        self.greetingText = " Hi " + childName + "!"
        greetingLabel.text = self.greetingText
        let total = selectedChild["total"] as! Double

        self.fundsText = "You have" + Utils.translateFunds(total)

        totalLabel.text = " Total Funds: " + String(format: "$%.2f", total)
        collectionView.delegate = self
        collectionView.dataSource = self
        getFeedback()
//        coinImageView.image = UIImage(named: "coin1")

    }

    @IBAction func onButtonClick(_ sender: Any) {
        coinImageView.animationImages = animatedImages(for: "starcoinrotate")
        coinImageView.animationDuration = 0.9
        coinImageView.animationRepeatCount = 2
        coinImageView.image = coinImageView.animationImages?.first
        coinImageView.startAnimating()
        
    }
    func getFeedback() {
        let query = PFQuery(className: "ChildFeedback")
        query.whereKey("child", equalTo: selectedChild)
        query.includeKeys(["amount", "description", "approved"])
        query.findObjectsInBackground { (feedback, error) in
            if feedback != nil {
                self.feedbackArray = feedback!
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBAction func greetingButton(_ sender: Any) {
        Utils.speak(self.greetingText)
    }
    
    @IBAction func totalFundsButton(_ sender: Any) {
        Utils.speak(self.fundsText)
    }
    
    @IBAction func earnMoneyButton(_ sender: Any) {
        Utils.speak("Earn Money")
    }
    
    @IBAction func goalsButton(_ sender: Any) {
        Utils.speak("Goals")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedbackArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedbackCollectionViewCell", for: indexPath) as! FeedbackCollectionViewCell
        let feedback = feedbackArray[indexPath.item]
        let amount = feedback["amount"] as! Double
        let approvedStatus = feedback["approved"] as! Bool
        if approvedStatus == true {
            cell.feedbackImageView.image = UIImage(named: "starcoinrotate/0")
            print("approved")
            cell.feedbackAmountLabel.text = String(format: "$%.2f", amount)

        }
//        else {
//            cell.feedbackImageView.image = UIImage(systemName: "hand.thumbsdown.fill")
//        }
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell clicked", indexPath)
        let cell = collectionView.cellForItem(at: indexPath) as! FeedbackCollectionViewCell
        cell.feedbackImageView.animationImages = animatedImages(for: "starcoinrotate")
        cell.feedbackImageView.animationDuration = 0.9
        cell.feedbackImageView.animationRepeatCount = 2
        cell.feedbackImageView.image = cell.feedbackImageView.animationImages?.first
        cell.feedbackImageView.startAnimating()
        print(type(of: indexPath))
        self.perform(#selector(afterAnimation), with: indexPath, afterDelay: cell.feedbackImageView.animationDuration * 3)
    }
    
    @objc func afterAnimation(indexPath: IndexPath) {
        print(indexPath)
        print("test")
        let feedback = self.feedbackArray[indexPath.item] as PFObject
        feedback.deleteInBackground { (success, error) in
            if success {
                self.feedbackArray.remove(at: indexPath.item)
                self.collectionView.deleteItems(at: [indexPath])
                self.collectionView.reloadData()
            }
        }
        
    }
    
    func animatedImages(for name: String) -> [UIImage] {
        //https://medium.com/dev-genius/how-to-animate-your-images-in-swift-ios-swift-guide-64de30ea616b
        var i = 0
        var images = [UIImage]()
        
        while let image = UIImage(named: "\(name)/\(i)") {
            images.append(image)
            i += 1
        }
        return images
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "childChoresSegue" {
            print("loading child chores")
            let childChoresViewController = segue.destination as! ChildChoresViewController
            childChoresViewController.selectedChild = selectedChild
                      
        }
        if segue.identifier == "childGoalsSegue" {
            print("loading child goals")
            let childGoalsViewController = segue.destination as! ChildGoalsViewController
            childGoalsViewController.selectedChild = selectedChild
                      
        }
    }
    

}


//<a href='https://www.freepik.com/vectors/background'>Background vector created by iconicbestiary - www.freepik.com</a>
//<a href='https://www.freepik.com/vectors/money'>Money vector created by rawpixel.com - www.freepik.com</a>

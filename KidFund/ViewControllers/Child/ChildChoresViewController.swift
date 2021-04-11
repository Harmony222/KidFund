//
//  ChildChoresViewController.swift
//  KidFund
//
//  Created by Harmony Scarlet on 4/9/21.
//

import UIKit
import Parse
import AVFoundation

class ChildChoresViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    
    @IBOutlet weak var childNameLabel: UILabel!
    var selectedChild = PFObject(className: "Children");
    var childChores = [PFObject]()
    @IBOutlet weak var choreCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = selectedChild["name"]
        childNameLabel.text = (name as? String)! + "'s Tasks"
        
        choreCollectionView.delegate = self
        choreCollectionView.dataSource = self
        
        getChores()
        // Do any additional setup after loading the view.
    }
    
    func getChores() {
        let query = PFQuery(className: "ChildChores")
        query.whereKey("child", equalTo: selectedChild)
        query.includeKeys(["chore", "chore.description", "chore.amount", "chore.image", "child", "child.name", "customAmount"])
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
        let chore = ChildChore["chore"] as! PFObject
        
        let description = chore["description"] as! String
        let amount = ChildChore["customAmount"] as! Double

        cell.choreDescription.text = description
        cell.choreAmount.text = String(format: "$%.2f", amount)

        let imageFile = chore["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        cell.choreImageView.af.setImage(withURL: url)
        
        cell.speakButton.tag = indexPath.item
        cell.speakButton.addTarget(self, action: #selector(speakButton), for: .touchUpInside)
                
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
    
    @objc func speakButton(sender:UIButton) {
        let indexpath1 = IndexPath(item: sender.tag, section: 0)

        let ChildChore = self.childChores[indexpath1.item] as PFObject
        let chore = ChildChore["chore"] as! PFObject
        let description = chore["description"] as! String
        let amount = ChildChore["customAmount"] as! Double
        let amountText = "This will earn you" + Utils.translateFunds(amount)
        Utils.speak(description + ". " + amountText)

   }

    @IBAction func instructionsSpeakButton(_ sender: Any) {
        Utils.speak("Select a task to complete it.")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "", message: "Complete this task?", preferredStyle: .alert)
        Utils.speak("Complete this task? Select no or yes.")

        alertController.addAction(UIAlertAction(title: NSLocalizedString("NO", comment: "Default action"), style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("YES", comment: "Default action"), style: .default, handler: { _ in
            let ChildChore = self.childChores[indexPath.item] as PFObject
            let choreToApprove = PFObject(className: "ChoresToApprove")
            choreToApprove["toApprove"] = ChildChore
            let date = Date()
            print(date)
            choreToApprove["date"] = date

            choreToApprove.saveInBackground { (success, error) in
                if success {
                    print("child's chore sent for approval")
                    let alert = Utils.createAlert("Sent to your parent for approval!")
                    Utils.speak("Sent to your parent for approval!")
                    self.present(alert, animated: true, completion: nil)
                } else {
                    print("error adding child/chore for approval")
                }
            }
        }))

        self.present(alertController, animated: true, completion: nil)
        
        
        
//        //https://stackoverflow.com/questions/49935711/adding-borders-on-collectionview-cell
//        print(indexPath.item)
//        let cell = collectionView.cellForItem(at: indexPath) as! ChoreCollectionViewCell
//        cell.layer.borderColor = UIColor(named: "AppGreenBlue")?.cgColor
//        cell.layer.borderWidth = 2
//        cell.isSelected = true
//        let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert);
//        // Add Action
//        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil));
//        //show it
//        let btnImage    = UIImage(systemName: "checkmark.square")
//        let imageButton : UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        imageButton.setBackgroundImage(btnImage, for: UIControl.State())
//        alertController.view.addSubview(imageButton)
//        self.present(alertController, animated: true, completion: {
//            () -> Void in
//        })
//        let chore = chores[indexPath.item]
////        let customAmountStr = cell.customAmount.text ?? "0"
////        let customAmount = Double(customAmountStr)!
//        // add chore to array when selected
//        selectedChores.append(chore)
////        customAmounts.append(customAmount)
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




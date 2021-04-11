//
//  ApproveChoresViewController.swift
//  KidFund
//
//  Created by Harmony Scarlet on 4/9/21.
//

import UIKit
import Parse

class ApproveChoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var toApprove = [PFObject]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        checkForChoresToApprove()
    }
    
    func checkForChoresToApprove() {
        let query = PFQuery(className: "ChoresToApprove")
        query.includeKeys(["toApprove", "toApprove.child", "toApprove.chore"])
        query.findObjectsInBackground { (toApprove, error) in
            if toApprove != nil {
                self.toApprove = toApprove!
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        toApprove.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApproveChoreTableViewCell", for: indexPath) as! ApproveChoreTableViewCell
        let toApprove = self.toApprove[indexPath.item] as PFObject
        let ChildChore = toApprove["toApprove"] as! PFObject
        let child = ChildChore["child"] as! PFObject
        let chore = ChildChore["chore"] as! PFObject
        
        let childName = child["name"] as! String
        let description = chore["description"] as! String
        let amount = ChildChore["customAmount"] as! Double
        let date = toApprove["date"] as! Date
        
        cell.childNameLabel.text = childName
        cell.choreDescriptionLabel.text = description
        cell.choreAmountLabel.text = String(format: "$%.2f", amount)
        
        let localDateFormatter = DateFormatter()
        localDateFormatter.dateStyle = .medium
        print(localDateFormatter.string(from: date))
        cell.dateLabel.text = "Date submitted: " + localDateFormatter.string(from: date)
        
        cell.approvalButton.tag = indexPath.row
        cell.approvalButton.addTarget(self, action: #selector(approvalButton), for: .touchUpInside)
        cell.denialButton.tag = indexPath.row
        cell.denialButton.addTarget(self, action: #selector(denialButton), for: .touchUpInside)
        return cell
    }

    @objc func approvalButton(sender:UIButton) {
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let toApprove = self.toApprove[indexpath.item] as PFObject

        let ChildChore = toApprove["toApprove"] as! PFObject
        let child = ChildChore["child"] as! PFObject
        let chore = ChildChore["chore"] as! PFObject
        
        // calculate new total
        let prevTotal = child["total"] as! Double
        let amount = ChildChore["customAmount"] as! Double
        let newTotal = prevTotal + amount

        let childFeedback = PFObject(className: "ChildFeedback")
        
        childFeedback["child"] = child
        childFeedback["amount"] = amount
        childFeedback["description"] = chore["description"]
        childFeedback["approved"] = true
              
        childFeedback.saveInBackground { (success, error) in
            if success {
                print("child feedback added!")
            } else {
                print("error adding child feedback")
            }
        }
        
        // update child's total in database and remove toApprove instance
        child["total"] = newTotal
        child.saveInBackground()
//        toApprove.deleteEventually()
        toApprove.deleteInBackground { (success, error) in
            if success {

                self.toApprove.remove(at: indexpath.row)
                self.tableView.deleteRows(at: [indexpath], with: .fade)
                self.tableView.reloadData()
                
            }
        }

        

    }
    
    @objc func denialButton(sender:UIButton) {
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let toApprove = self.toApprove[indexpath.item] as PFObject
        
//        let ChildChore = toApprove["toApprove"] as! PFObject
//        let child = ChildChore["child"] as! PFObject
//        let chore = ChildChore["chore"] as! PFObject
//
//        let amount = ChildChore["customAmount"] as! Double

//        let childFeedback = PFObject(className: "ChildFeedback")
//        
//        childFeedback["child"] = child
//        childFeedback["amount"] = amount
//        childFeedback["description"] = chore["description"]
//        childFeedback["approved"] = false
//              
//        childFeedback.saveInBackground { (success, error) in
//            if success {
//                print("child feedback added!")
//            } else {
//                print("error adding child feedback")
//            }
//        }
        // remove DENIED chore from approval list
        toApprove.deleteInBackground { (success, error) in
            if success {

                self.toApprove.remove(at: indexpath.row)
                self.tableView.deleteRows(at: [indexpath], with: .fade)
                self.tableView.reloadData()
                
            }
        }

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

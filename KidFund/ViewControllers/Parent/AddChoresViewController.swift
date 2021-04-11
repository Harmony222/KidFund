//
//  AddChoresViewController.swift
//  KidFund
//
//  Created by Harmony Scarlet on 4/8/21.
//

import UIKit
import Parse
import AlamofireImage

class AddChoresViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {

    var selectedChild = PFObject(className: "Children");
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var choreCollectionView: UICollectionView!
    let myRefreshControl = UIRefreshControl()

    var chores = [PFObject]()
    var numberOfCells: Int!
    var selectedChores = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(selectedChild["name"]!)
        let childName = selectedChild["name"] as! String
        greetingLabel.text = "Adding chores for " + childName
        
        choreCollectionView.delegate = self
        choreCollectionView.dataSource = self
        self.choreCollectionView.allowsMultipleSelection = true
        self.choreCollectionView.allowsMultipleSelectionDuringEditing = true
        
        getChores()
        myRefreshControl.addTarget(self, action: #selector(getChores), for: .valueChanged)
        choreCollectionView.refreshControl = myRefreshControl
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectedChores.removeAll()
        getChores()
    }
    
    @objc func getChores() {
        let query = PFQuery(className: "Chores")
        query.includeKeys(["description", "amount", "image"])
        query.findObjectsInBackground { (chores, error) in
            if chores != nil {
                self.chores = chores!
                self.choreCollectionView.reloadData()
                self.myRefreshControl.endRefreshing()
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        chores.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChoreCollectionViewCell", for: indexPath) as! ChoreCollectionViewCell
        let chore = chores[indexPath.item]
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
        
        if cell.isSelected {
            //put border logic
            cell.layer.borderColor = UIColor(named: "AppGreenBlue")?.cgColor
            cell.layer.borderWidth = 3
        }else {
            // remove border
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.borderWidth = 3
        }
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //https://stackoverflow.com/questions/49935711/adding-borders-on-collectionview-cell
        print(indexPath.item)
        let cell = collectionView.cellForItem(at: indexPath) as! ChoreCollectionViewCell
        cell.layer.borderColor = UIColor(named: "AppGreenBlue")?.cgColor
        cell.layer.borderWidth = 3
        cell.isSelected = true
        let chore = chores[indexPath.item]
//        let customAmountStr = cell.customAmount.text ?? "0"
//        let customAmount = Double(customAmountStr)!
        // add chore to array when selected
        selectedChores.append(chore)
//        customAmounts.append(customAmount)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ChoreCollectionViewCell
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 3
        cell.isSelected = false
        let chore = chores[indexPath.item]
        // remove chore from array upon deselect
        if let index = selectedChores.firstIndex(of: chore) {
            selectedChores.remove(at: index)
        }
    }
    
    @IBAction func onDoneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAddSelectedChoresButton(_ sender: Any) {
//        var duplicateFound = false
        for selected in self.selectedChores {
            print(selected["description"] as! String)
            
            // check ChildChores for duplicate
            let query = PFQuery(className: "ChildChores")
            query.whereKey("child", equalTo: selectedChild)
            query.whereKey("chore", equalTo: selected)
            
            query.findObjectsInBackground { (childChores, error) in
                if childChores!.count != 0 {
                    print(childChores!)
                    print("child/chore is duplicate, not added")
//                    duplicateFound = true

                } else {
                    // if no duplicates, add Child + Chore to table
                    let chore = PFObject(className: "ChildChores")
                    chore["child"] = self.selectedChild
                    chore["chore"] = selected
                    chore["customAmount"] = selected["amount"]
                    chore.saveInBackground { (success, error) in
                        if success {
                            print("child's chore added")

                        } else {
                            print("error adding child's chore")
                        }
                    }
                }
            }
                     
        }
        // doesn't work here, duplicateFound evaluates to False since this code runs before the findObjectsInBackground finishes.
//        if duplicateFound == true {
//            print("test")
//            let alert = Utils.createAlert("Duplicate tasks detected, duplicates not added.")
//            self.present(alert, animated: true, completion: nil)
//        }

        selectedChores.removeAll()
        choreCollectionView.deselectAllItems(animated: true)
        self.choreCollectionView.reloadData()

    }
    
    

// Chores images reference
// <a href='https://www.freepik.com/vectors/kids'>Kids vector created by macrovector - www.freepik.com</a>
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "createChoreSegue" {
            print("loading create Chore")
            let createChoreViewController = segue.destination as! CreateCustomChoreViewController
            createChoreViewController.selectedChild = selectedChild
                      
        }
    }
    

}

extension UICollectionView {

    func deselectAllItems(animated: Bool) {
        guard let selectedItems = indexPathsForSelectedItems else { return }
        for indexPath in selectedItems { deselectItem(at: indexPath, animated: animated) }
    }
}

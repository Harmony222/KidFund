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

    var chores = [PFObject]()
    var numberOfCells: Int!
    var selectedChores = [PFObject]()
    var customAmounts = [Double]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(selectedChild["name"]!)
        let childName = selectedChild["name"] as! String
        greetingLabel.text = "Adding chores for " + childName
        
        choreCollectionView.delegate = self
        choreCollectionView.dataSource = self
        self.choreCollectionView.allowsMultipleSelection = true
        self.choreCollectionView.allowsMultipleSelectionDuringEditing = true
//        let layout = choreCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.minimumLineSpacing = 4
//        layout.minimumInteritemSpacing = 4
//        let width = (view.frame.size.width - layout.minimumInteritemSpacing) / 2
//
//        layout.itemSize = CGSize(width: width, height: width/2)
        
        let query = PFQuery(className: "Chores")
//        query.whereKeyDoesNotExist("child")
        query.includeKeys(["description", "amount", "image"])
        query.findObjectsInBackground { (chores, error) in
            if chores != nil {
                self.chores = chores!
                self.choreCollectionView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
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
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        let cell = collectionView.cellForItem(at: indexPath) as! ChoreCollectionViewCell
        let myColor = UIColor(red: 0.365, green: 0.953, blue: 0.884, alpha: 1.00)
        cell.layer.borderColor = myColor.cgColor
        cell.layer.borderWidth = 2
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
        cell.layer.borderWidth = 2
        cell.isSelected = false
        let chore = chores[indexPath.item]
        // remove chore from array upon deselect
        if let index = selectedChores.firstIndex(of: chore) {
            selectedChores.remove(at: index)
        }
    }
    
    
    @IBAction func onAddSelectedChoresButton(_ sender: Any) {
        
        for selected in self.selectedChores {
            print(selected["description"] as! String)
            let chore = PFObject(className: "ChildChores")
            chore["child"] = self.selectedChild
            chore["chore"] = selected

            self.selectedChild.add(chore, forKey: "chores")
            selectedChild.saveInBackground { (success, error) in
                if success {
                    print("child's chore added")
                    
                } else {
                    print("error adding child's chore")
                }
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

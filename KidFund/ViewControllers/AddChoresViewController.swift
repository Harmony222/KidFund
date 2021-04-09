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
        
        if cell.isSelected {
            //put border logic
            cell.layer.borderColor = UIColor(named: "AppGreenBlue")?.cgColor
            cell.layer.borderWidth = 2
        }else {
            // remove border
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.borderWidth = 2
        }
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //https://stackoverflow.com/questions/49935711/adding-borders-on-collectionview-cell
        print(indexPath.item)
        let cell = collectionView.cellForItem(at: indexPath) as! ChoreCollectionViewCell
        cell.layer.borderColor = UIColor(named: "AppGreenBlue")?.cgColor
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
//        choreCollectionView.indexPathsForSelectedItems?.forEach({ choreCollectionView.deselectItem(at: $0, animated: false) })
        selectedChores.removeAll()
        choreCollectionView.deselectAllItems(animated: true)
        self.choreCollectionView.reloadData()

    }
    
    

// Chores images reference
// <a href='https://www.freepik.com/vectors/kids'>Kids vector created by macrovector - www.freepik.com</a>
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UICollectionView {

    func deselectAllItems(animated: Bool) {
        guard let selectedItems = indexPathsForSelectedItems else { return }
        for indexPath in selectedItems { deselectItem(at: indexPath, animated: animated) }
    }
}

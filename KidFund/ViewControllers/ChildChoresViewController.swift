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
        childNameLabel.text = name as? String
        
        choreCollectionView.delegate = self
        choreCollectionView.dataSource = self
        
        getChores()
        // Do any additional setup after loading the view.
    }
    
    func getChores() {
        let query = PFQuery(className: "ChildChores")
        query.whereKey("child", equalTo: selectedChild)
        query.includeKeys(["chore", "chore.description", "chore.amount", "chore.image"])
        query.findObjectsInBackground { (chores, error) in
            if chores != nil {
                self.childChores = chores!
                self.choreCollectionView.reloadData()
            }
        }
    }
    
    func speak(_ speakString: String) {
        let speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: speakString)
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.5
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(speechUtterance)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childChores.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChoreCollectionViewCell", for: indexPath) as! ChoreCollectionViewCell

        let ChildChore = self.childChores[indexPath.item] as PFObject
        let chore = ChildChore["chore"] as! PFObject
        
        let description = chore["description"] as! String
        let amount = chore["amount"] as! Double

        cell.choreDescription.text = description
        cell.choreAmount.text = String(format: "$%.2f", amount)

        cell.speakerImage.title = description
        let imageFile = chore["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        cell.choreImageView.af.setImage(withURL: url)
        

//        let tapGestureRecognizer = CustomTapGesture(target: self, action: #selector(self.imageTapped(_:)))
//        cell.speakerImage.isUserInteractionEnabled = true
//        cell.speakerImage.addGestureRecognizer(tapGestureRecognizer)
//        tapGestureRecognizer.title = description

        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
    
    @IBAction func speakerTapped(_ sender: Any) {
        
    }
    
    func imageTapped(sender: CustomTapGesture)
    {
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
        speak(sender.title)
        // Your action
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

class CustomTapGesture: UITapGestureRecognizer {
    var title = String()
}



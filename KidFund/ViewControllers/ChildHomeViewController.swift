//
//  ChildHomeViewController.swift
//  KidFund
//
//  Created by Harmony Scarlet on 4/8/21.
//

import UIKit
import Parse
import AVFoundation

class ChildHomeViewController: UIViewController {
    
    var selectedChild = PFObject(className: "Children");
    var greetingText = ""
    var fundsText = ""
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var dollarsCentsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedChild["name"]!)
        let childName = selectedChild["name"] as! String
        self.greetingText = "Hi " + childName + "!"
        greetingLabel.text = self.greetingText
        let total = selectedChild["total"] as! Double
        let dollars = floor(total)
        let dollarsStr = String(Int(dollars))
        let cents = floor(total.truncatingRemainder(dividingBy: 1) * 100)
        let centsStr = String(Int(cents))
        self.fundsText = "You have " + dollarsStr + " dollars and " + centsStr + " cents!"
//        dollarsCentsLabel.text = fundsString
        totalLabel.text = "Total Funds: " + String(format: "$%.2f", total)
        
//        speak(greetingText + " " + fundsString)

        
//        let speechSynthesizer = AVSpeechSynthesizer()
//        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: greetingText + " " + fundsString)
//        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.5
//        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//        speechSynthesizer.speak(speechUtterance)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func greetingButton(_ sender: Any) {
        speak(self.greetingText)
    }
    
    @IBAction func totalFundsButton(_ sender: Any) {
        speak(self.fundsText)
    }
    
    @IBAction func earnMoneyButton(_ sender: Any) {
        speak("Earn Money")
    }
    
    @IBAction func goalsButton(_ sender: Any) {
        speak("Goals")
    }
    
    func speak(_ speakString: String) {
        let speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: speakString)
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.5
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(speechUtterance)
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

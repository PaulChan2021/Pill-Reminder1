//
//  HealthcareViewController.swift
//  Pill-Reminder
//
//  Created by mac on 25/5/2022.
//

import UIKit
import ApiAI
import AVFoundation

class HealthcareViewController: UIViewController {

    @IBOutlet weak var messagesField: UITextField!
    @IBOutlet weak var responseLabel: UILabel!
    
    @IBAction func sendButton(_ sender: Any) {
        
        let request = ApiAI.shared().textRequest()
        
        if let text = self.messagesField.text, text != "" {
            request?.query = text
        } else {
            return
        }
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if let textResponse = response.result.fulfillment.speech {
                self.speechAndText(text: textResponse)
            }
        }, failure: { (request, error) in
            print(error!)
        })
        
        ApiAI.shared().enqueue(request)
        messagesField.text = ""
    }
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    func speechAndText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.responseLabel.text = text
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

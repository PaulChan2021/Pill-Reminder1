//
//  ViewController.swift
//  Pill-Reminder
//
//  Created by mac on 9/3/2022.
//

import UIKit
import AVKit
import LocalAuthentication

class ViewController: UIViewController {
    // AVPlayer item and point to mp4 file and initialize AVplayer
    var VideoPlayer:AVPlayer?
    var Videolayer:AVPlayerLayer?
    
    var context = LAContext()
    var err : NSError?
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var faceIDButton: UIButton!
    
    override func viewDidLoad() {
        
    super.viewDidLoad()
        // Do setup after loading the view.
        setUpElements()
        // store data and retrieve data from core data
     
    }

    override func viewWillAppear(_ animated: Bool) {
        // video for login background
        backgroundSetup()
    }
    
    func setUpElements() {
        
        Designs.styleFilledButton(signUpButton)
        Designs.styleHollowButton(loginButton)
        Designs.styleTouchFaceButton(faceIDButton)
    }
    
    func backgroundSetup() {
        //get resource and create URL
        let Path = Bundle.main.path(forResource: "ICON_VERSION7", ofType: "mp4")
        guard Path != nil else{
            return
        }
        let url = URL(fileURLWithPath: Path!)
        // display video for background and scaling
        let VideoItem = AVPlayerItem(url: url)
        VideoPlayer = AVPlayer(playerItem: VideoItem)
        
        // create the layer
        Videolayer = AVPlayerLayer(player: VideoPlayer!)
        
        // scaling
        Videolayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)

        view.layer.insertSublayer(Videolayer!, at: 0)
        
        // play video in login background
        VideoPlayer?.playImmediately(atRate: 0.3)
    }
@IBAction func faceTouchTapped(_ sender: Any) {

        let context = LAContext()

        var error:NSError?
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            // Device can user bio authentication
            context.evaluatePolicy(
                LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Access requires authentication", reply: {(success, error) in DispatchQueue.main.async {
                    if let err = error {
                        switch err._code {

                        case LAError.Code.systemCancel.rawValue:
                            self.notifyUser("Session cancelled", err: err.localizedDescription)
                            
                        case LAError.Code.userCancel.rawValue:
                            self.notifyUser("Please try again", err: err.localizedDescription)
                        
                        case LAError.Code.userFallback.rawValue:
                            self.notifyUser("Authentication", err: "Password option selected")
                        default:
                            self.notifyUser("Authentication failed", err: err.localizedDescription)
                        }
                    } else {
                        // The app will transition to Homepage if login successful
                       self.notifyUser("Authentication Successful", err: "You now have full access")
                        
                        let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                        
                        self.view.window?.rootViewController = homeViewController
                        self.view.window?.makeKeyAndVisible()
                    }
                }
            })
        } else {
            // Device can't use bio
            if let err = error {
                switch err.code {
                    
                case LAError.Code.biometryNotEnrolled.rawValue:
                    notifyUser("User is not enrolled", err: err.localizedDescription)
                    
                case LAError.Code.passcodeNotSet.rawValue:
                    notifyUser("A passcode has not been set", err: err.localizedDescription)
                
                case LAError.Code.biometryNotAvailable.rawValue:
                    notifyUser("Biometric authentication not available", err: err.localizedDescription)
                default:
                    notifyUser("Unknown error", err: err.localizedDescription)
                }
            }
        }
    }
    
    func notifyUser(_ msg: String, err: String?) {
        let alert = UIAlertController(title: msg, message: err, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)

    }
}


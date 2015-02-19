//
//  ViewController.swift
//  touchID_test
//
//  Created by Zhehao Zhou on 2/17/15.
//  Copyright (c) 2015 Zhehao Zhou. All rights reserved.
//

import UIKit
import LocalAuthentication
// link the LocalAuthentication library in building

class ViewController: UIViewController, UIAlertViewDelegate{

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label.text = "Nope" // text lable shows Nope before passing the touchID test
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startAuthenticate(sender: UIButton) {
        var control:UIControl = UIControl()
        control.sendAction(Selector("authenticateUser"), to: self, forEvent: nil)
        // begin touchID test before starting fingerPrint scanning.
    }
    
    func authenticateUser(){
        let context = LAContext()
        var error: NSError?
        var reasonString = "TouchID Authentication is needed to access further detail -- viczzh"
        // TouchID test will always start in a UIAlert form
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
        // this statement tests if the current device has touchID function
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
                if (success){
                        self.label!.text = "Secret Shows"
                        // additional steps after the touchID has been approved
                }else{
                    switch evalPolicyError!.code{
                        case LAError.SystemCancel.rawValue:
                        // the originally toRaw() has been changed to rawValue
                            println("Authentication was cancelled by the system")
                        case LAError.UserCancel.rawValue:
                            println("Authentication was cancelled by the user")
                        case LAError.UserFallback.rawValue:
                            println("User selected to enter custom password")
                            self.showPasswordAlert()
                        default:
                            println("Authentication failed")
                            self.showPasswordAlert()
                    }
                }
            })
        }else{
            NSLog("This Device do not have TounchID Function")
        }
    }
    // the alert will shows after the authentication fails in limited time.
    func showPasswordAlert() {
        var passwordAlert : UIAlertView = UIAlertView(title: "Password", message: "Please type your password", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Okay")
        passwordAlert.alertViewStyle = UIAlertViewStyle.SecureTextInput
        passwordAlert.show()
    }
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            if !alertView.textFieldAtIndex(0)!.text.isEmpty {
                if alertView.textFieldAtIndex(0)!.text == "viczzh" {
                // I cannot find a way to let device authenticate if it matches the TouchID password. Thus, it needs filling in the selected password, e.g. viczzh is the password
                    self.label!.text = "Secret"
                }else{
                    showPasswordAlert()
                    // keep showing the alert if the authentication fails.
                }
            }else{
                showPasswordAlert()
            }
        }
    }
}

//
//  LoginViewController.swift
//  NearBY
//
//  Created by Anantha Krishnan K G on 11/03/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UIGestureRecognizerDelegate,UITextFieldDelegate {

    let notificationName = Notification.Name("sendFeedBack1")
    @IBOutlet var userName: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.errorLabel.isHidden = true
        self.loginButton.layer.cornerRadius = 10.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.tap))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardDidShow(notification:)), name:NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.loadMain), name: NSNotification.Name(rawValue: "sendFeedBack1"), object: nil)
        
        
    }
    func tap() {
        self.view.endEditing(true)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    func keyboardDidShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                //isKeyboardActive = false
                UIView.animate(withDuration: duration,
                               delay: TimeInterval(0),
                               options: animationCurve,
                               animations: {
                                // move scroll view height to 0.0
                                self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                                
                },
                               completion: { _ in
                })
            } else {
                //isKeyboardActive = true
                
                var userInfo = notification.userInfo!
                var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
                keyboardFrame = self.view.convert(keyboardFrame, from: nil)
                
                
                UIView.animate(withDuration: duration,
                               delay: TimeInterval(0),
                               options: animationCurve,
                               animations: {
                                // move scroll view height to    endFrame?.size.height ?? 0.0
                                self.view.frame = CGRect(x: 0, y:  -(keyboardFrame.size.height), width: self.view.frame.size.width, height: self.view.frame.size.height)
                                
                },
                               completion: { _ in
                })
            }
        }
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.errorLabel.isHidden = true;
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func loadMain(notification: NSNotification){
        
        // performSegue(withIdentifier: "unwind1", sender: self)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signIn(_ sender: Any) {
        
        if (!(userName.text?.isEmpty)! && !(password.text?.isEmpty)!){
            MyChallengeHandler.loginG(password: password.text!, userName: userName.text!)
        } else{
            self.errorLabel.text = "Invalid UserName and password"
            self.errorLabel.isHidden = false
        }
    }
}

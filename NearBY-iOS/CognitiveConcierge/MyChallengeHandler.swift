//
//  MyChallengeHandler.swift
//  NearBY
//
//  Created by Anantha Krishnan K G on 11/03/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit
import BMSAnalytics
import BMSCore
import IBMMobileFirstPlatformFoundation

class MyChallengeHandler: SecurityCheckChallengeHandler {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let securityCheckName = "UserLogin"
    
    
    override init(){
        super.init(securityCheck: securityCheckName)
        WLClient.sharedInstance().registerChallengeHandler(self)
    }
    
    override func handleSuccess(_ success: [AnyHashable : Any]!) {
        let user = success["user"]! as! [String:Any]
        let displayName = user["displayName"] as! String
        let logger = Logger.logger(name: "My Logger")
        logger.info(message: displayName+"opened the app")
        Logger.send(completionHandler: { (response: Response?, error: Error?) in
            if let response = response {
                print("Status code: \(response.statusCode)")
                print("Response: \(response.responseText)")
            }
            if let error = error {
                logger.error(message: "Failed to send logs. Error: \(error)")
            }
        })
        UserDefaults.standard.setValue(displayName, forKey: "userName");
        UserDefaults.standard.synchronize()
        
    }
    
    static func loginG(password:String, userName:String){
        
        WLAuthorizationManager.sharedInstance().login("UserLogin", withCredentials: ["username": userName, "password": password, "rememberMe": true]) { (error) -> Void in
            if(error != nil){
                print("Login failed \(String(describing: error))")
            } else {
                print(": preemptiveLogin success")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sendFeedBack1"), object:nil)
            }
        }
    }
    
    
}

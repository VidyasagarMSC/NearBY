/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import UIKit
import BMSCore
import BMSAnalytics
import BMSPush
import CoreLocation
import OpenWhisk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    
    var pushAppGUID:String = "2913bfe5-a3fc-4401-93ba-0fada156dda0"
    var pushAppClientSecret:String = "afab35fd-d588-4fd5-8ba7-786b61844629"
    var pushAppSecret:String = "afab35fd-d588-4fd5-8ba7-786b61844629"
    var pushAppRegion:String = ".ng.bluemix.net"
    var whiskAccessKey:String = "9908ebc9-7385-4460-b5d9-eb88541a76e3"
    var whiskaccessToken:String = "DkNWqzA6e1c6of2pLTZdjE5EShRgheXtbfx0hQWjZfhXWnDCCfdqFuP1R7z9k9fb"
    var whiskActionName:String = "SendLocationUpdate"
    var whiskSpaceName:String = "IMF_Push_kgspace"
    
    var locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let configurationPath = Bundle.main.path(forResource: "CognitiveConcierge", ofType: "plist")
        {
            let configuration = NSDictionary(contentsOfFile: configurationPath)
            
            //Initialization - Bluemix Mobile Analytics
            BMSClient.sharedInstance.initialize(bluemixRegion: BMSClient.Region.usSouth)
            Analytics.initialize(appName: "NearBY", apiKey: configuration?["BluemixMobileAnalytics"] as! String, hasUserContext: false, deviceEvents: .lifecycle, .network)
            
            Analytics.isEnabled = true
            Analytics.userIdentity="VMac"
            Logger.isLogStorageEnabled = true
            Logger.isInternalDebugLoggingEnabled = true
            Logger.logLevelFilter = LogLevel.debug
            let logger = Logger.logger(name: "My Logger")
            logger.debug(message: "Logging from AppDelegate.Swift")
            Logger.send(completionHandler: { (response: Response?, error: Error?) in
                if let response = response {
                    print("Status code: \(response.statusCode)")
                    print("Response: \(response.responseText)")
                }
                if let error = error {
                    logger.error(message: "Failed to send logs. Error: \(error)")
                }
            })
            
            Analytics.send(completionHandler: { (response: Response?, error: Error?) in
                if let response = response {
                    print("Status code: \(response.statusCode)")
                    print("Response: \(response.responseText)")
                }
                if let error = error {
                    logger.error(message: "Failed to send analytics. Error: \(error)")
                }
            })
            
            startSignificantChangeLocationUpdates()
            _ = MyChallengeHandler();

        }
        else {
            print("problem loading configuration file CognitiveConcierge.plist")
            return false
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        BMSPushClient.sharedInstance.registerWithDeviceToken(deviceToken: deviceToken) { (response, statusCode, error) in
            
            if error.isEmpty {
                
                print( "Response during device registration : \(response)")
                
                print( "status code during device registration : \(statusCode)")
            }else{
                print( "Error during device registration \(error) ")
                
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error registering for push notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let payLoad = ((((userInfo as NSDictionary).value(forKey: "aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as! NSString)
        
        self.showAlert(title: "Recieved Push notifications", message: payLoad as String)
        let push =  BMSPushClient.sharedInstance
        
        let respJson = (userInfo as NSDictionary).value(forKey: "payload") as! String
        let data = respJson.data(using: String.Encoding.utf8)
        
        let jsonResponse:NSDictionary = try! JSONSerialization.jsonObject(with: data! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        
        let messageId:String = jsonResponse.value(forKey: "nid") as! String
        push.sendMessageDeliveryStatus(messageId: messageId) { (res, ss, ee) in
            completionHandler(UIBackgroundFetchResult.newData)
        }
        
    }
    
    func showAlert (title:String , message:String){
        
        // create the alert
        let alert = UIAlertController.init(title: title , message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.window!.rootViewController!.present(alert, animated: true, completion: nil)
    }
    
    //MARK: LOCATION UPDATES
    func startSignificantChangeLocationUpdates() {
        // Create a location manager object
        self.locationManager = CLLocationManager()
        
        // Set the delegate
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 1000.00
        self.locationManager.activityType = CLActivityType.automotiveNavigation
        
        // Request location authorization
        self.locationManager.requestAlwaysAuthorization()
        
        // Start significant-change location updates
        self.locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(locations.last!) { (placemarks, error) in
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            if (placemarks!.count) > 0 {
                let pm = (placemarks?[0])! as CLPlacemark
                print(pm.locality)
                
                let credentialsConfiguration = WhiskCredentials(accessKey:self.whiskAccessKey, accessToken: self.whiskaccessToken)
                
                let whisk = Whisk(credentials: credentialsConfiguration)
                whisk.verboseReplies = true
                
                var devId = String()
                let authManager  = BMSClient.sharedInstance.authorizationManager
                devId = authManager.deviceIdentity.ID!;
                
                var params = Dictionary<String, String>()
                params["location"] = pm.locality!
                params["deviceIds"] = devId
                params["appID"] = self.pushAppGUID
                params["appSecret"] = self.pushAppSecret
                
                do {
                    try whisk.invokeAction(name: self.whiskActionName, package: "", namespace: self.whiskSpaceName, parameters: params as AnyObject?, hasResult: true, callback: {(reply, error) -> Void in
                        
                        if let error = error {
                            //do something
                            print("Error invoking action \(error.localizedDescription)")
                            
                        } else {
                            print("Success")
                        }
                        
                    })
                } catch {
                    print("Error \(error)")
                }
            }
            else {
                print("Problem with the data received from geocoder")
            }
        }
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        self.locationManager.stopMonitoringSignificantLocationChanges()
        
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.locationManager.startMonitoringSignificantLocationChanges()
    }

    
}


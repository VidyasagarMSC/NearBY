func main(args: [String:Any]) -> [String:Any] {
    
    let deviceAarray = args["deviceIds"] as? String;
    let location = args["location"] as? String;
    let appID = args["appID"] as? String;
    let appSecret = args["appSecret"] as? String;
    let message = "Reached \(location!). Lets check the best Restaurants."
    let devArray = [deviceAarray!]
    
    let result = Whisk.invoke(actionNamed:"/whisk.system/pushnotifications/sendMessage",withParameters:["appSecret":appSecret!,"appId":appID!,"text":message,"deviceIds":devArray])
    return [ "Result" : result ]
}

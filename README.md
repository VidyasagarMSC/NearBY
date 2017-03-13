# NearBY - An iOS travel Advisor app Powered by IBM Bluemix (Mobile Services, Watson, Kitura)

NearBY is inspired from [CognitiveConcierge](https://github.com/IBM-MIL/CognitiveConcierge).
CognitiveConcierge is an end-to-end Swift application sample with an iOS front end and a Kitura web framework back end.  

## Enhancements 

- Auto detection of Location using CLLocationManager.
- Bluemix Mobile Analytics.
- Plug and play options (You can add any category like museums, movie-theater etc.,).
- Flexible Kitura calls. Easy to add Google Place types.
- Push Notification via OpenWhisk whenever there is a significant location change.

More to follow....


*Note*: Most of the UI and backend is adopted from CognitiveConcierge app.

## NearBY-Server 
[Kitura](http://www.kitura.io) is a lightweight HTTP Web framework written in Swift allowing you to write complex routes easily and quickly. 

You will be using Kitura to talk to Google Places API. 

### Obtain a Google Places API Key for Web

For this project, you'll need an API Key from Google Places. Instructions for obtaining a key can be found [here](https://developers.google.com/places/web-service/get-api-key).

Once you have an API Key, go to the Google Developer's Console, and enable the Google Places API for iOS as well. Make note of the API key for later use in your server and iOS applications. Wait at least 10 minutes for the key to become active.

### Clone, Create & Deploy the Server Application to Bluemix using ICT.

1. Install [IBM Cloud Tools for Swift] (http://cloudtools.bluemix.net/) for MacOS.
2. Once you've installed the application, you can open it to get started.
3. Goto IBM Cloud Tools for Swift( App Menu) -> Advanced -> Create Sample Project from Github Repo and paste this link **https://github.com/VidyasagarMSC/NearBY** and click Next.
4. Give a unique name to your project. Also a unique name (without special characters) to your Cloud Runtime (Server-Side). Click Save Files to Local Computer to clone the project.
5. This deployment to Bluemix may take a few minutes. Your Kitura server and other Bluemix services required for your app is provisioned along with the deployment.

6. Once the project is cloned, open up the .xcodeproj file that was created for you in ICT under Local Server Repository. Edit the Sources/restaurant-recommendations/Configuration.swift file's Constants struct with your own Google API Key for Web.

	<img src="images/xcodeproj.png" width="500">


### Point iOS Application to Server Application
1. In ICT, ensure that the Connected to: field in the Client application is pointed to your server instance running on Bluemix.  You can also point to your localhost for local testing, but you need to be running a local instance of the server application for this to work.

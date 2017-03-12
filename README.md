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

For this project, you'll need an API Key from Google Places, so that app can have access to review text which will be sent to the Natural Language Understanding service for analysis. Instructions for obtaining a key can be found [here](https://developers.google.com/places/web-service/get-api-key).

Once you have an API Key, go to the Google Developer's Console, and enable the Google Places API for iOS as well. Make note of the API key for later use in your server and iOS applications.

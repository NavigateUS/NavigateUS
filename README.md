# NavigateUS

A new Flutter project.

## Getting Started

### Google Maps API Key

- Get an [API key](https://cloud.google.com/maps-platform/) from Google Maps Platform
- Enable Google Map SDK for each platform according to [this guide](https://pub.dev/packages/google_maps_flutter).

#### Android

In ```android/app/src/main/AndroidManifest.xml```, change ```YOURKEYHERE``` in 
```
<meta-data android:name="com.google.android.geo.API_KEY"
            android:value="YOURKE   YHERE"/>
```
to the API key from above.

#### iOS

In ```ios/Runner/AppDelegate.swift```, change ```YOURKEYHERE``` in
```
GMSServices.provideAPIKey("YOURKEYHERE")
```
to the API key from above.






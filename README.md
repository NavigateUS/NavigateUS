# NavigateUS

A new Flutter project.

## For Orbital Evuluators

### Downloading and installing android studio and emulator

To test the app, you will need to download and install android studio.

Please refer to this [video guide](https://www.youtube.com/watch?v=1ukSR1GRtMU&ab_channel=TheNetNinja) to do so.

After that, you will need to get an android emulator.

Please refer to this [video guide](https://www.youtube.com/watch?v=TSIhiZ5jRB0&list=PL4cUxeGkcC9jLYyp2Aoh6hcWuxFDX6PBJ&index=4&ab_channel=TheNetNinja) to do so. You do not need to create a flutter project.

Clone this repository and open it in flutter.

### Testing the app

When the app is run, you will need to enable location services. To do this, you will have to go to recent apps by pressing the square button on the bottom right. Afterwards, longpress on the app icon and select 'App info'. Click on 'Permissions', then on 'Location' and select 'Allow all the time'. Location services is now enabled.

To set your current location, click the ellipsis (...) on the menu on the right. Under the location tab, you can search for a location and save it as a point. Click on that point under 'Saved points' and click 'Set location'. Your currrent location is now set. 

You can now test the app with different user positions.


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





